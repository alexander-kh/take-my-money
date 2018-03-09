class ExecutesStripePaymentJob < ActiveJob::Base
  
  queue_as :default
  
  def perform(payment, stripe_token)
    charge_action = ExecutesStripePayment.new(payment: payment,
      stripe_token: stripe_token)
    charge_action.run
  end
end