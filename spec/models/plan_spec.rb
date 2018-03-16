require 'rails_helper'

RSpec.describe Plan, type: :model do
  let(:plan) { build_stubbed(:plan) }
  
  context "end date" do
    it "calculates daily end date" do
      plan.interval = "day"
      date = Date.parse("Mar 10, 2018")
      
      expect(plan.end_date_from(date)).to eq(Date.parse("Mar 11, 2018"))
    end
  end
end
