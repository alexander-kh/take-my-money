require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe "#place_in_cart_for" do
    it "changes ticket status and set the user" do
      user = create(:user)
      ticket = create(:ticket, status: "unsold",
                      performance: create(:performance, event: create(:event)))
      
      ticket.place_in_cart_for(user)
      
      expect(ticket.user).to eq(user)
      expect(ticket.status).to eq("waiting")
    end
  end
end
