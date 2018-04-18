class AddressesController < ApplicationController
  
  def new
    @address = Address.new
  end
  
  def create
    workflow = AddsShippingToCart.new(
      user: current_user, address: params[:address].permit!,
      method: params[:shipping_method])
    workflow.run
    if workflow.success?
      redirect_to shopping_cart_path
    else
      render :new
    end
  end
end