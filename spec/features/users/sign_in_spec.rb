require 'rails_helper'

RSpec.feature "Sign in", :devise do
  scenario "user cannot sign in if not registered" do
    sign_in("test@example.com", "password")
    
    expect(page).to have_content(
      I18n.t("devise.failure.not_found_in_database",
        authentication_keys: "Email"))
  end
  
  scenario "user can sign in with valid credentials" do
    user = FactoryBot.create(:user)
    
    sign_in(user.email, user.password)
    
    expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
  end
  
  scenario "user cannot sign in with wrong email" do
    user = FactoryBot.create(:user)
    
    sign_in("invalid@email.com", user.password)
    
    expect(page).to have_content(
      I18n.t("devise.failure.not_found_in_database",
        authentication_keys: "Email"))
  end
  
  scenario "user cannot sign in with wrong password" do
    user = FactoryBot.create(:user)
    
    sign_in(user.email, "1234")
    
    expect(page).to have_content(
      I18n.t("devise.failure.invalid", authentication_keys: "Email"))
  end
end