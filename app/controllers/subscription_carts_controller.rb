class SubscriptionCartsController < ApplicationController
  
  def show
    @cart = SubscriptionCart.new(current_user)
  end
  
  def update
    plan = Plan.find(params[:plan_id])
    workflow = AddsPlanToCart.new(user: current_user, plan: plan)
    workflow.run
    if workflow.result
      redirect_to subscription_cart_path
    else
      redirect_to plans_path
    end
  end
end