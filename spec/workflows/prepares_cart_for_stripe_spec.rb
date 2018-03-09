require 'rails_helper'

RSpec.describe PreparesCartForStripe, :vcr, :aggregate_failures do
  let(:performance) { create(:performance, event: create(:event)) }
  let(:reference) { Payment.generate_reference } 
  let(:ticket_1) { create(
    :ticket, status: "waiting",
             price: Money.new(1500),
             performance: performance,
             payment_reference: "reference") }
  let(:ticket_2) { create(
    :ticket, status: "waiting",
             price: Money.new(1500),
             performance: performance,
             payment_reference: "reference") }
  let(:ticket_3) { create(
    :ticket, status: "unsold",
             performance: performance,
             payment_reference: "reference") }
  let(:user) { create(:user) }
  let(:workflow) { PreparesCartForStripe.new(
    user: user, purchase_amount_cents: 3000, stripe_token: token,
    expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}",
    payment_reference: "reference") }
  let(:attributes) {
    {user_id: user.id, price_cents: 3000, reference: a_truthy_value,
     payment_method: "stripe", status: "created"} }
  
  before(:example) do
    [ticket_1, ticket_2].each { |t| t.place_in_cart_for(user) }
  end

  describe "successful credit card payment" do
    let(:token) { StripeToken.new(
      credit_card_number: "4242424242424242", expiration_month: "12",
      expiration_year: Time.zone.now.year + 1, cvc: "123") }

    it "updates the ticket status" do
      workflow.run
      
      expect(Ticket.find(ticket_1.id)).to be_purchased
      expect(Ticket.find(ticket_2.id)).to be_purchased
      expect(Ticket.find(ticket_3.id)).not_to be_purchased
      expect(workflow.payment_attributes).to match(attributes)
      expect(workflow.success).to be_truthy
      expect(workflow.payment.payment_line_items.size).to eq(2)
    end
  end
  
  describe "pre-flight fails" do
    let(:token) { instance_spy(StripeToken) }
    
    describe "expected price" do
      let(:workflow) { PreparesCartForStripe.new(
        user: user, purchase_amount_cents: 2500, stripe_token: token,
        expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}") }
      
      it "does not trigger payment if the expected price is incorrect" do
        expect { workflow.run }.to raise_error(ChargeSetupValidityException)
        expect(workflow).not_to be_pre_purchase_valid
        expect(Ticket.find(ticket_1.id)).to be_waiting
        expect(Ticket.find(ticket_2.id)).to be_waiting
        expect(Ticket.find(ticket_3.id)).to be_unsold
        expect(workflow.success).to be_falsy
        expect(workflow.payment).to be_nil
      end
    end
    
    describe "expected tickets" do
      let(:workflow) { PreparesCartForStripe.new(
        user: user, purchase_amount_cents: 3000, stripe_token: token,
        expected_ticket_ids: "#{ticket_1.id} #{ticket_3.id}") }
      
      it "does not trigger payment if the expected tickets are incorrect" do
        expect { workflow.run }.to raise_error(ChargeSetupValidityException)
        expect(workflow).not_to be_pre_purchase_valid
        expect(Ticket.find(ticket_1.id)).to be_waiting
        expect(Ticket.find(ticket_2.id)).to be_waiting
        expect(Ticket.find(ticket_3.id)).to be_unsold
        expect(workflow.success).to be_falsy
        expect(workflow.payment).to be_nil
      end
    end
  end
end