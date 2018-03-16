require 'rails_helper'

RSpec.describe "User cancels subscription", :vcr do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, remote_id: "orchestra_monthly",
    nickname: "Orchestra Monthly") }
  let!(:subscription) { Subscription.create(user: user, plan: plan,
    start_date: Time.zone.now.to_date, end_date: plan.end_date_from,
    status: :waiting) }
  let(:token) { StripeToken.new(
    credit_card_number: "4242424242424242", expiration_month: "12",
    expiration_year: Time.zone.now.year + 1, cvc: "123") }
  let(:workflow) { CreatesSubscriptionViaStripe.new(
    user: user, expected_subscription_id: [subscription.id], token: token) }
  
  before(:example) do
    sign_in(user.email, user.password)
    workflow.run
  end
  
  scenario "via stripe" do
    visit user_path(user)
    
    within("#subscription_#{subscription.id}") do
      click_on("cancel")
    end
    
    expect(current_url).to match("users")
    expect(page).to have_content("Subscription was successfully canceled")
  end
end