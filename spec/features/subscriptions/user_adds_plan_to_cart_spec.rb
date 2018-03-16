require 'rails_helper'

RSpec.describe "User adds a subscription plan to the cart" do
  let(:user) { create(:user) }
  let!(:plan) { create(:plan, remote_id: "orchestra_monthly",
    nickname: "Orchestra Monthly", price_cents: 30_000, status: :active) }
  
  before(:example) do
    sign_in(user.email, user.password)
  end
  
  scenario "happy path" do
    visit plans_path
    
    within("#plan_#{plan.id}") do
      click_on("add-to-cart")
    end
    
    expect(current_url).to match("cart")
    within("#subscription_#{user.subscriptions.last.id}") do
      expect(page).to have_selector(".subtotal", text: "$300")
    end
  end
end