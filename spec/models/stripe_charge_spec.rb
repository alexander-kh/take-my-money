require 'rails_helper'

RSpec.describe StripeCharge, :vcr do
  let(:token) { StripeToken.new(
    credit_card_number: "4242424242424242", expiration_month: "12",
    expiration_year: Time.zone.now.year + 1, cvc: "123") }
  let(:payment) { build_stubbed(
    :payment, price: Money.new(3000), reference: Payment.generate_reference) }
  
  it "calls stripe to get a charge" do
    charge = StripeCharge.charge(token: token, payment: payment)
    
    expect(charge.id).to start_with("ch_")
    expect(charge.amount).to eq(3000)
  end
end