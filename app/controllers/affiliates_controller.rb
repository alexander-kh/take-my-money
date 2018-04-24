class AffiliatesController < ApplicationController
  
  def new
  end
  
  def show
    @affiliate = Affiliate.find(params[:id])
  end
  
  def edit
    @affiliate = Affiliate.find(params[:id])
  end
  
  def update
    @affiliate = Affiliate.find(params[:id])
    workflow = UpdatesAffiliateAccount.new(
      affiliate: @affiliate, user: current_user,
      params: params[:account].permit!.to_h)
    workflow.run
    if workflow.success
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end
  
  def create
    workflow = AddsAffiliateAccount.new(
      user: current_user, tos_checked: params[:tos],
      request_ip: request.remote_ip)
    workflow.run
    if workflow.success
      redirect_to user_path(current_user)
    else
      render :new
    end
  end
end