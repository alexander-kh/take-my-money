require 'rails_helper'

RSpec.feature "Sign out", :devise do
  scenario "user signs out successfully" do
    user = FactoryBot.create(:user)
    sign_in(user.email, user.password)
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
    
    click_link("Sign out")
    
    expect(page).to have_content(I18n.t("devise.sessions.signed_out"))
  end
end