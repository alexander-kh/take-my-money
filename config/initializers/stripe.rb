Stripe.api_key = Rails.application.secrets.stripe_secret_key
raise "Missing Stripe API Key" unless Stripe.api_key
STRIPE_JS_HOST = "https://js.stripe.com".freeze unless defined? STRIPE_JS_HOST
STRIPE_JS_FILE = Rails.env.development? ? "stripe-debug.js" : ""