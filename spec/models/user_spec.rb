require 'rails_helper'

RSpec.describe User do
  
  before(:each) { @user = User.new(email: "user@example.com") }
  
  subject { @user }
  
  it { is_expected.to respond_to(:email) }
  
  it "#email returns a string" do
    expect(@user.email).to match("user@example.com")
  end
end
