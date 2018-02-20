require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe ".generate_reference" do
    
    before(:example) do
      allow(SecureRandom).to receive(:hex).and_return("first", "second")
    end
    
    it "generates a reference" do
      expect(Payment.generate_reference).to eq("first")
    end
    
    it "avoids duplicates" do
      create(:payment, reference: "first", user: create(:user))
      
      expect(Payment.generate_reference).to eq("second")
    end
  end
end
