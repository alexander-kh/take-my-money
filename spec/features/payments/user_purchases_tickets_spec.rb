require 'rails_helper'
require 'fake_stripe'

RSpec.describe "User purchases tickets", :js do
  let(:buyer) { create(:user) }
  let(:performance) { create(:performance, event: create(:event)) }
  
  let(:ticket_1) { create(:ticket, performance: performance,
    status: "unsold", price: Money.new(1500))}
  let(:ticket_2) { create(:ticket, performance: performance,
    status: "unsold", price: Money.new(1500))}
  
  before(:each) do
    FakeStripe.stub_stripe
  end
  
  after(:each) do
    WebMock.reset!
    Stripe.api_key = Rails.application.secrets.stripe_secret_key
  end
    
  before(:example) do
    sign_in(buyer.email, buyer.password)
    ticket_1.place_in_cart_for(buyer)
    ticket_2.place_in_cart_for(buyer)
  end
  
  scenario "with the valid credit card" do
    visit shopping_cart_path
    fill_in :credit_card_number, with: "4242 4242 4242 4242"
    fill_in :expiration_date, with: "12 / #{Time.zone.now + 1}"
    fill_in :cvc, with: "123"
    click_on "purchase"
    
    expect(page).to have_content("Payment is pending, check back for updates")
    # expect(page).to have_selector(".purchased_ticket", count: 2)
    # expect(page).to have_selector("#purchased_ticket_#{ticket_1.id}")
    # expect(page).to have_selector("#purchased_ticket_#{ticket_2.id}")
  end
end