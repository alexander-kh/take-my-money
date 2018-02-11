require 'rails_helper'

RSpec.describe AddsToCart do
  let(:user) { instance_double(User) }
  let(:performance) { instance_double(Performance) }
  let(:ticket_1) { instance_spy(Ticket, status: "unsold") }
  let(:ticket_2) { instance_spy(Ticket, status: "unsold") }
  
  context "when there are enough tickets to fulfill the order" do
    it "adds tickets to the shopping cart" do
      expect(performance).to receive(:unsold_tickets).with(1).
        and_return([ticket_1])
      workflow = AddsToCart.new(user: user, performance: performance, count: 1)
      
      workflow.run
      
      expect(workflow.success).to be(true)
      expect(ticket_1).to have_received(:place_in_cart_for).with(user)
      expect(ticket_2).not_to have_received(:place_in_cart_for)
    end
  end
  
  context "when there are not enough tickets to fulfill the order" do
    it "does not add tickets to the shopping cart" do
      expect(performance).to receive(:unsold_tickets).with(1).
        and_return([])
      workflow = AddsToCart.new(user: user, performance: performance, count: 1)
      
      workflow.run
      
      expect(workflow.success).to be(false)
      expect(ticket_1).not_to have_received(:place_in_cart_for)
      expect(ticket_2).not_to have_received(:place_in_cart_for)
    end
  end
end