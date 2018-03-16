require 'rails_helper'

RSpec.describe CancelsStripeSubscription, :vcr, :aggregate_failures do
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
      
    before(:example) do
      workflow.run
    end
    
    it "cancels stripe subscription" do
      action = CancelsStripeSubscription.new(
        subscription_id: subscription.id, user: user)
      
      action.run
      subscription.reload
      
      expect(subscription).to be_canceled
    end
  end
end