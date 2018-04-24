require 'rails_helper'

RSpec.describe StripeAccount, :vcr do
  
  describe "updating" do
    let(:affiliate_user) { create(:user) }
    let(:affiliate_workflow) {
      AddsAffiliateAccount.new(user: affiliate_user) }
    let(:account) { affiliate_workflow.account }
    let(:values) { {
      legal_entity: {first_name: "Alexander",
                     dob: {day: 27, month: 10, year: 1985}}} }
    
    it "updates the account from a hash" do
      affiliate_workflow.run
      account.update(values)
      
      expect(account.account.legal_entity.first_name).to eq("Alexander")
      expect(account.account.legal_entity.dob.day).to eq(27)
      expect(account.account.legal_entity.dob.month).to eq(10)
      expect(account.account.legal_entity.dob.year).to eq(1985)
    end
  end
end