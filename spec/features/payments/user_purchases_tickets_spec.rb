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
  
  context "when adding a discount code", :slow do
    let!(:discount_code) { create(
      :discount_code, code: "CODE", percentage: 25) }
    
    it "comes back to the form on a discount", :slow do
      visit shopping_cart_path
      fill_in :discount_code, with: "CODE"
      click_on "apply_code"
      
      expect(page).to have_selector(".active_code", text: "CODE")
      expect(page).to have_selector(".total", text: "$23.50")
    end
  end
  
  context "when adding a shipping method" do
    
    it "comes back to the cart with shipping" do
      visit shopping_cart_path
      click_on "shipping_details"
      fill_in "address_address_1", with: "1060 W. Addison"
      fill_in "address_city", with: "Chicago"
      select "Illinois", from: "address_state"
      fill_in "address_zip", with: "60613"
      select "Overnight", from: "shipping_method"
      click_on "add_address"
      
      expect(page).to have_selector(
        ".active_shipping_method", text: "overnight")
      expect(page).to have_selector(".total", text: "$41")
    end
  end
end