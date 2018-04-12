unless Rails.env.test? || Rails.env.production?
  
  options = {forward_emails_to: "alex.khlipun@icloud.com",
             deliver_emails_to: ["@snowglobetheater.com"]}
  
  interceptor = MailInterceptor::Interceptor.new(options)
  
  ActionMailer::Base.register_interceptor(interceptor)
  
  EmailPrefixer.configure do |config|
    config.application_name = "Snow Globe"
  end
end