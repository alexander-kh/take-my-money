require 'rails_helper'

RSpec.describe DayRevenue, type: :model do
  let!(:really_old_payment) { create(
    :payment, created_at: 1.month.ago, price_cents: 4500) }
  let!(:really_old_payment_2) { create(
    :payment, created_at: 1.month.ago, price_cents: 1500) }
  let!(:old_payment) { create(
    :payment, created_at: 2.days.ago, price_cents: 3500) }
  let(:performance) { create(:performance, event: create(:event)) }
  let!(:ticket) { create(:ticket, performance: performance) }
  let!(:payment_line_item) { create(
    :payment_line_item, payment: really_old_payment, buyable: ticket,
                        created_at: 1.month.ago) }
  
  it "builds data" do
    revenue = DayRevenue.build_for(1.month.ago)
    
    expect(revenue.price_cents).to eq(6000)
    expect(revenue.ticket_count).to eq(1)
  end
end
