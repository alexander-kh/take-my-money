require 'rails_helper'

RSpec.feature "Home page" do
  scenario "visit the home page" do
    visit root_path
    
    expect(page).to have_content("Welcome")
  end
end