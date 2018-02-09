class ShoppingCartsController < ApplicationController
  
  def update
    performance = Performance.find(params[:performance_id])
    workflow = AddsToCart.new(
      user: current_user, performance: performance,
      count: params[:ticket_count])
    workflow.run
    if workflow.success
      redirect_to shopping_cart_path
    else
      redirect_to performance.event
    end
  end
end