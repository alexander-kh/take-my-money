require 'rails_helper'

RSpec.describe ShoppingCartsController do
  describe "PATCH #update" do
    let(:user) { instance_spy(User) }
    let(:performance) { instance_spy(
      Performance, event: build_stubbed(:event)) }
    let(:workflow) { instance_spy(AddsToCart) }
    
    before(:example) do
      allow(controller).to receive(:current_user).and_return(user)
      allow(Performance).to receive(:find).with("2").and_return(performance)
      allow(AddsToCart).to receive(:new).with(
        user: user, performance: performance, count: "1").and_return(workflow)
    end
    
    context "when successful" do
      it "adds tickets to a shopping cart" do
        allow(workflow).to receive(:success).and_return(true)
        
        patch :update, params: { performance_id: "2", ticket_count: "1" }
        
        expect(workflow).to have_received(:run)
        expect(controller).to redirect_to(shopping_cart_path)
      end
    end
    
    context "when unsuccessful" do
      it "redirects back to the event" do
        allow(workflow).to receive(:success).and_return(false)
        
        patch :update, params: { performance_id: "2", ticket_count: "1" }
        
        expect(workflow).to have_received(:run)
        expect(controller).to redirect_to(performance.event)
      end
    end
  end
end