class Users::SessionsController < Devise::SessionsController
  
  skip_before_action :set_paper_trail_whodunnit
  
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.authy_id.present?
      if @user&.valid_password?(params[:user][:password])
        session[:awaiting_authy_user_id] = @user.id
        Authy::API.request_sms(id: @user.authy_id)
        render :two_factor
      else
        render :new
      end
    else
      session[:awaiting_authy_user_id] = nil
      super
    end
  end
  
  def two_factor
  end
  
  def verify
    @user = User.find(session[:awaiting_authy_user_id])
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])
    if token.ok?
      set_flash_message!(:notice, :signed_in)
      sign_in(User, @user)
      session[:awaiting_authy_user_id] = nil
      respond_with @user, location: after_sign_in_path_for(resource)
    else
      flash[:danger] = "Incorrect code, please try again"
      redirect_to users_sessions_two_factor_path
    end
  end
  
  def delete
    session[:awaiting_authy_user_id] = nil
    super
  end
end
