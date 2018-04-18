class DiscountCodesController < ApplicationController
  
  def create
    workflow = AddsDiscountCodeToCart.new(
      user: current_user, code: params[:discount_code])
    workflow.run
    redirect_to shopping_cart_path
  end
end