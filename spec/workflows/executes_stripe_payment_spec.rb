require 'rails_helper'

RSpec.describe ExecutesStripePayment, :vcr, :aggregate_failures do
  let(:user) { create(:user) }
  let(:payment) { Payment.create(
    user_id: user.id, price_cents: 2500, status: "created",
    reference: Payment.generate_reference, payment_method: "stripe") }
  let(:action) { ExecutesStripePayment.new(
    payment: payment, stripe_token: token.id) }
  
  describe "successful credit card payment" do
    let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }
    
    before(:example) do
      action.run
    end
    
    it "takes the response from the gateway" do
      expect(action.payment).to have_attributes(
        status: "succeeded", response_id: a_string_starting_with("ch_"),
        full_response: action.stripe_charge.response.to_json)
    end
  end
  
  describe "an unsuccessful credit card payment" do
    let(:token) { StripeToken.new(
      credit_card_number: "4000000000000002", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }
    
    before(:example) do
      expect(action).to receive(:unpurchase_tickets)
      action.run
    end
    
    it "takes the response from the gateway" do
      expect(action.payment).to have_attributes(
        status: "failed", response_id: nil,
        full_response: action.stripe_charge.error.to_json)
    end
  end
end