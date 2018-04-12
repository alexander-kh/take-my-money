require 'rails_helper'

RSpec.describe CashPurchasesCart, :aggregate_failures do
  describe "successful cash purchase" do
    let(:performance) { create(:performance, event: create(:event)) }
    let(:ticket_1) { create(
      :ticket, status: "waiting",
               price: Money.new(1500), performance: performance,
               payment_reference: "reference") }
    let(:ticket_2) { create(
      :ticket, status: "waiting",
               price: Money.new(1500), performance: performance,
               payment_reference: "reference") }
    let(:ticket_3) { create(
      :ticket, status: "unsold",
               performance: performance,
               payment_reference: "reference") }
    let(:user) { create(:user) }
    let(:discount_code) { nil }
    let(:discount_code_string) { nil }
    let(:workflow) { CashPurchasesCart.new(
      user: user,
      purchase_amount_cents: 3000,
      expected_ticket_ids: "1 2",
      payment_reference: "reference",
      discount_code_string: discount_code_string) }
    let(:attributes) { {user_id: user.id, price_cents: 3000,
                        reference: a_truthy_value, payment_method: "cash",
                        status: "succeeded", administrator_id: user.id,
                        discount_code_id: nil, discount: Money.zero} }
    
    context "with an administrative user" do
      before(:example) do
        allow(user).to receive(:admin?).and_return(true)
        [ticket_1, ticket_2].each { |t| t.place_in_cart_for(user) }
      end
      
      it "updates the ticket status" do
        workflow.run
        
        expect(Ticket.find(ticket_1.id)).to be_purchased
        expect(Ticket.find(ticket_2.id)).to be_purchased
        expect(Ticket.find(ticket_3.id)).not_to be_purchased
        expect(workflow.success).to be_truthy
        expect(workflow.payment_attributes).to match(attributes)
        expect(workflow.payment.payment_line_items.size).to eq(2)
      end
    end
    
    context "with a regular user" do
      before(:example) do
        allow(user).to receive(:admin?).and_return(false)
      end
      
      it "fails" do
        expect { workflow.run }.to raise_error(UnathorizedPurchaseException)
        expect(workflow.success?).to be_falsy
        expect(workflow.payment).to be_nil
        expect(Ticket.find(ticket_1.id)).not_to be_purchased
        expect(Ticket.find(ticket_2.id)).not_to be_purchased
        expect(Ticket.find(ticket_3.id)).not_to be_purchased
      end
    end
  end
end