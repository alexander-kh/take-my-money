require 'rails_helper'

RSpec.feature "User delete", :devise do
  scenario "user can delete own account" do
    user = FactoryBot.create(:user)
    sign_in(user.email, user.password)
    
    visit edit_user_registration_path(user)
    click_button("Cancel my account")
    
    expect(page).to have_content(I18n.t("devise.registrations.destroyed"))
  end
end