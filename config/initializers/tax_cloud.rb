TaxCloud.configure do |config|
  config.api_login_id = Rails.application.secrets.tax_cloud_login
  config.api_key = Rails.application.secrets.tax_cloud_key
end