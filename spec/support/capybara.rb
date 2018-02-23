require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.asset_host = "http://localhost:3000"
Capybara.javascript_driver = :poltergeist