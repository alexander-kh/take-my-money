class UsersController < ApplicationController
  
  before_action :load_user
  
  def show
  end
  
  def edit
  end
  
  def update
    @user.update(user_params)
    authorize(@user)
    render :show
  end
  
  private
  
  def load_user
    @user = User.find(params[:id])
    authorize(@user)
  end
  
  def user_params
    params.require(:user).permit(:name)
  end
end