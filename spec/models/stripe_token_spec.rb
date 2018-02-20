require 'rails_helper'

RSpec.describe StripeToken, :vcr do
  it "calls stripe to get a token" do
    token = StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123")
    
    expect(token.id).to start_with("tok_")
  end
end