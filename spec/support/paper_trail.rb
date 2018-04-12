RSpec.configure do |config|
  config.before(:each) do
    PaperTrail.enabled = false
  end
end