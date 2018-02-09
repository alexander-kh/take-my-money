require 'rails_helper'

RSpec.describe Performance, type: :model do
  describe "#unsold_tickets" do
    let(:event) { create(:event) }
    let(:performance) { create(:performance, event: event) }
    let(:unsold_ticket) { create(
      :ticket, status: "unsold", performance: performance) }
    
    it "finds unsold tickets" do
      expect(performance.unsold_tickets(1)).to eq([unsold_ticket])
    end
  end
end
