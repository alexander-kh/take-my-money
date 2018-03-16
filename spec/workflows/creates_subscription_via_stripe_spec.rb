require 'rails_helper'

RSpec.describe CreatesSubscriptionViaStripe, :vcr, :aggregate_failures do
  describe "happy path" do
    let(:user) { create(:user) }
    let(:plan) { create(:plan, remote_id: "orchestra_monthly",
      nickname: "Orchestra Monthly") }
    let(:subscription) { Subscription.create!(
      user: user, plan: plan, status: :waiting) }
    let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }
    let(:workflow) { CreatesSubscriptionViaStripe.new(
      user: user, expected_subscription_id: [subscription.id], token: token) }
    
    
    it "creates a customer" do
      workflow.run
      subscription.reload
      
      expect(subscription).to be_pending_initial_payment
      expect(user.stripe_id).to be_present
      expect(subscription.payment_method).to eq("stripe")
      expect(subscription.remote_id).to be_present
    end
  end
end