require 'rails_helper'

RSpec.feature "User edit", :devise do
  scenario "user changes email address" do
    user = FactoryBot.create(:user)
    sign_in(user.email, user.password)
    
    visit edit_user_registration_path(user)
    fill_in "Email", with: "newmail@example.com"
    fill_in "Current password", with: user.password
    click_button "Update"
    
    txts = [I18n.t("devise.registrations.updated"),
            I18n.t("devise.registrations.update_needs_confirmation")]
    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end
  
  scenario "user cannot edit another user's profile" do
    user = FactoryBot.create(:user)
    another_user = FactoryBot.create(:user, email: "other@example.com")
    
    sign_in(user.email, user.password)
    visit edit_user_registration_path(another_user)
    
    expect(page).to have_content("Edit User")
    expect(page).to have_field("Email", with: user.email)
  end
end