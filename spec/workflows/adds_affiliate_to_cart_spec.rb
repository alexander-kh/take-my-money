require 'rails_helper'

RSpec.describe AddsAffiliateToCart do
  let(:user) { create(:user) }
  let!(:affiliate) { create(:affiliate, tag: "tag") }
  
  it "adds tag to cart if cart exists" do
    workflow = AddsAffiliateToCart.new(tag: "tag", user: user)
    
    workflow.run
    
    expect(ShoppingCart.for(user:user).affiliate).to eq(affiliate)
  end
  
  it "manages if the tag doesn't exist" do
    workflow = AddsAffiliateToCart.new(tag: "banana", user: user)
    
    workflow.run
    
    expect(ShoppingCart.for(user: user).affiliate).to be_nil
  end
  
  it "manages if the tag is nil" do
    workflow = AddsAffiliateToCart.new(tag: nil, user: user)
    
    workflow.run
    
    expect(ShoppingCart.for(user: user).affiliate).to be_nil
  end
  
  it "correctly adds tag if the case is wrong" do
    workflow = AddsAffiliateToCart.new(tag: "TAG", user: user)
    
    workflow.run
    
    expect(ShoppingCart.for(user: user).affiliate).to eq(affiliate)
  end
  
  it "does nothing if there is no current user" do
    workflow = AddsAffiliateToCart.new(tag: "tag", user: nil)
    
    workflow.run
    
    expect(ShoppingCart.for(user: nil)).to be_nil
  end
  
  it "does nothing if the affiliate belongs to the user" do
    affiliate.update(user: user)
    workflow = AddsAffiliateToCart.new(tag: "tag", user: user)
    
    workflow.run
    
    expect(ShoppingCart.for(user: user).affiliate).to be_nil
  end
end