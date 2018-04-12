class UserSimulationsController < ApplicationController
  
  def create
    @user_to_simulate = User.find(params[:id_to_simulate])
    authorize(@user_to_simulate, :simulate?)
    session[:admin_id] = current_user.id
    sign_in(:user, @user_to_simulate, bypass: true)
    redirect_to root_path
  end
  
  def destroy
    redirect_to(admin_users_path) && return if simulating_admin_user.nil?
    sign_in(:user, simulating_admin_user, bypass: true)
    session[:admin_id] = nil
    redirect_to admin_users_path
  end
end