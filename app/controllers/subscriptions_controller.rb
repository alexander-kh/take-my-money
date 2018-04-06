class SubscriptionsController < ApplicationController
  
  before_action :authenticate_user!
  
  def edit
    @subscription = Subscription.find(params[:id])
  end
  
  def update
    subscription = Subscription.find(params[:id])
    workflow = ChangesStripeSubscriptionPlan.new(
      subscription_id: subscription.id,
      user: current_user,
      new_plan_id: params[:new_plan])
    workflow.run
    if workflow.success
      redirect_to user_path(current_user),
        notice: "Subscription plan was successfully changed"
    end
  end
  
  def destroy
    subscription = Subscription.find(params[:id])
    workflow = CancelsStripeSubscription.new(
      subscription_id: subscription.id,
      user: current_user)
    workflow.run
    if workflow.success
      redirect_to user_path(current_user),
        notice: "Subscription was successfully canceled"
    end
  end
end