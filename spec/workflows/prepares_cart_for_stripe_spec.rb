require 'rails_helper'

RSpec.describe PreparesCartForStripe, :vcr, :aggregate_failures do
  let(:performance) { create(:performance, event: create(:event)) }
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
  let!(:purchase_amount_cents) { 3000 }
  let(:discount_code) { nil }
  let(:discount_code_string) { nil }
  let(:shopping_cart) { create(
    :shopping_cart, user: user, discount_code: discount_code,
                    shipping_method: :electronic) }
  let(:workflow) { PreparesCartForStripe.new(
    user: user, purchase_amount_cents: 3100,
    stripe_token: token, expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}",
    payment_reference: "reference", shopping_cart: shopping_cart) }
  let(:attributes) {
    {user_id: user.id, price_cents: 3100, reference: a_truthy_value,
     payment_method: "stripe", status: "created", discount_code_id: nil,
     discount: Money.zero, partials: {
       ticket_cents: [1500, 1500], processing_fee_cents: 100},
     shipping_method: "electronic", shipping_address: nil} }
  
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
      expect(ShoppingCart.find_by(user_id: user.id)).to be_nil
    end
    
    context "with a discount code" do
      let(:workflow) { PreparesCartForStripe.new(
        user: user, purchase_amount_cents: 2350,
        expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}",
        payment_reference: "reference", stripe_token: token,
        shopping_cart: shopping_cart) }
      let!(:discount_code) { create(
        :discount_code, percentage: 25, code: discount_code_string) }
      let(:discount_code_string) { "CODE" }
      
      it "creates a transaction object" do
        workflow.run
        
        expect(workflow.payment).to have_attributes(
          user_id: user.id, price_cents: 2350,
          partials: {
            "ticket_cents" => [1500, 1500],
            "processing_fee_cents" => 100,
            "discount_cents" => -750},
          reference: a_truthy_value, payment_method: "stripe")
        expect(workflow.payment.payment_line_items.size).to eq(2)
      end
    end
    
    context "with a shipping method" do
      let(:address) { create(:address) }
      let(:shopping_cart) { create(:shopping_cart,
        user: user, discount_code: discount_code,
        shipping_method: :standard, address: address) }
      let(:workflow) { PreparesCartForStripe.new(
        user: user, purchase_amount_cents: 3330,
        expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}",
        payment_reference: "reference", stripe_token: token,
        shopping_cart: shopping_cart) }
      
      it "handles shipping" do
        workflow.run
        
        expect(workflow.payment).to have_attributes(
          user_id: user.id, price_cents: 3330,
          partials: {
            "ticket_cents" => [1500, 1500],
            "processing_fee_cents" => 100,
            "shipping_cents" => 200,
            "sales_tax" =>
              {"ticket_cents" => 0.0, "processing_cents" => 10.0,
               "shipping_cents" => 20.0}},
          reference: a_truthy_value, payment_method: "stripe",
          shipping_address: address, shipping_method: "standard")
      end
    end
  end
  
  describe "pre-flight fails" do
    let(:token) { instance_spy(StripeToken) }
    
    describe "expected price" do
      let(:workflow) { PreparesCartForStripe.new(
        user: user, purchase_amount_cents: 2500, stripe_token: token,
        expected_ticket_ids: "#{ticket_1.id} #{ticket_2.id}",
        shopping_cart: shopping_cart) }
      
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
        expected_ticket_ids: "#{ticket_1.id} #{ticket_3.id}",
        shopping_cart: shopping_cart) }
      
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