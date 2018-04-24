require 'rails_helper'

RSpec.describe ExecutesStripePayment, :vcr, :aggregate_failures do
  let(:user) { create(:user) }
  let(:payment) { Payment.create(
    user_id: user.id, price_cents: 2500, status: "created",
    reference: Payment.generate_reference, payment_method: "stripe") }
  let(:workflow) { ExecutesStripePayment.new(
    payment: payment, stripe_token: token.id) }
  
  describe "successful credit card payment" do
    let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }
    
    context "without an affiliate" do
      before(:example) do
        workflow.run
      end

      it "takes the response from the gateway" do
        expect(workflow.payment).to have_attributes(
          status: "succeeded", response_id: a_string_starting_with("ch_"),
          full_response: workflow.stripe_charge.response.to_json)
      end
    end
    
    context "with an affiliate fee" do
      let(:affiliate_user) { create(:user, email: "affiliate@example.com") }
      let(:affiliate_workflow) {
        AddsAffiliateAccount.new(user: affiliate_user) }
      let(:affiliate) { affiliate_workflow.affiliate }

      before(:example) do
        affiliate_workflow.run
        payment.update(
          affiliate_id: affiliate.id, affiliate_payment_cents: 125)
        workflow.run
      end

      it "takes response from the gateway" do
        response = workflow.stripe_charge.response
        expect(workflow.payment).to have_attributes(
          status: "succeeded", response_id: a_string_starting_with("ch_"),
          full_response: response.to_json)
        fee = Stripe::ApplicationFee.retrieve(response.application_fee)

        expect(fee.amount).to eq(2375)
      end
    end
  end
  
  describe "an unsuccessful credit card payment" do
    let(:token) { StripeToken.new(
      credit_card_number: "4000000000000002", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }

    before(:example) do
      expect(workflow).to receive(:unpurchase_tickets)
      workflow.run
    end

    it "takes the response from the gateway" do
      expect(workflow.payment).to have_attributes(
        status: "failed", response_id: nil,
        full_response: workflow.stripe_charge.error.to_json)
    end
  end
end