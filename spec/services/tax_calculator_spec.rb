require 'rails_helper'

RSpec.describe TaxCalculator, :aggregate_failures, :vcr do
  let(:address) { build_stubbed(:address) }
  let(:user) { build_stubbed(:user) }
  let(:calculator) { TaxCalculator.new(
    user: user, address: address, cart_id: "1",
    items: [
      TaxCalculator::Item.create(:ticket, 1, Money.new(3000)),
      TaxCalculator::Item.create(:processing, 1, Money.new(100)),
      TaxCalculator::Item.create(:shipping, 1, Money.new(200))
    ]) }
  let(:transaction) { calculator.transaction }
  
  describe "creation" do
    it "creates a transaction properly" do
      expect(transaction).to have_attributes(customer_id: user.id, cart_id: "1")
      expect(transaction.origin).to have_attributes(
        address1: "1060 W. Addison", address2: nil,
        city: "Chicago", state: "IL", zip5: "60613")
      expect(transaction.destination).to have_attributes(
        address1: address.address_1, address2: address.address_2,
        city: address.city, state: address.state, zip5: address.zip)
      expect(transaction.cart_items.first).to have_attributes(
        index: 0, item_id: "Ticket",
        tic: "91083", price: 30.00, quantity: 1)
      expect(transaction.cart_items.second).to have_attributes(
        index: 1, item_id: "Processing",
        tic: "10010", price: 1.00, quantity: 1)
      expect(transaction.cart_items.third).to have_attributes(
        index: 2, item_id: "Shipping",
        tic: "11000", price: 2.00, quantity: 1)
    end
    
    it "handles a lookup correctly" do
      expect(calculator.tax_amount).to eq(0.30.to_money)
      expect(calculator.itemized_taxes).to eq(
        ticket_cents: 0.0, processing_cents: 10.0, shipping_cents: 20.0)
    end
  end
end