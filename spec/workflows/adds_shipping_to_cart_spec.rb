require 'rails_helper'

RSpec.describe AddsShippingToCart do
  let(:user) { create(:user) }
  let(:address) { attributes_for(:address) }
  let(:workflow) { AddsShippingToCart.new(
    user: user, address: address, method: :standard) }
  
  it "adds shipping to cart" do
    workflow.run
    cart = ShoppingCart.for(user: user)
    
    expect(cart.address).to have_attributes(address)
    expect(cart).to be_standard
    expect(workflow).to be_a_success
  end
  
  it "fails gracefully if a field is missing" do
    address.delete(:zip)
    workflow.run
    cart = ShoppingCart.for(user: user)
    
    expect(cart.address).to be_nil
    expect(cart.shipping_method).to eq("electronic")
    expect(workflow).not_to be_a_success
  end
end