require 'rails_helper'

RSpec.describe "User purchases a subscription plan", :vcr do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, remote_id: "orchestra_monthly",
    nickname: "Orchestra Monthly") }
  let!(:subscription) { Subscription.create(user: user, plan: plan,
    start_date: Time.zone.now.to_date, end_date: plan.end_date_from,
    status: :waiting) }
  let(:token) { StripeToken.new(
    credit_card_number: "4242424242424242", expiration_month: "12",
    expiration_year: Time.zone.now.year + 1, cvc: "123") }
  
  before(:example) do
    sign_in(user.email, user.password)
  end
  
  scenario "via stripe" do
    visit subscription_cart_path
    
    choose "credit_radio"
    find("#spec_stripe_token", visible: false).set(token.id)
    click_on "purchase"
    user.reload
    subscription.reload
    
    expect(user.stripe_id).not_to be_nil
    expect(subscription).to be_pending_initial_payment
  end
end