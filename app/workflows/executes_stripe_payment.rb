class ExecutesStripePayment
  
  attr_accessor :payment, :stripe_token, :stripe_charge
  
  def initialize(payment:, stripe_token:)
    @payment = payment
    @stripe_token = StripeToken.new(stripe_token: stripe_token)
  end
  
  def run
    Payment.transaction do
      result = charge
      on_failure unless result
    end
  end
  
  def charge
    return :present if payment.response_id.present?
    @stripe_charge = StripeCharge.new(token: stripe_token, payment: payment)
    @stripe_charge.charge
    payment.update!(@stripe_charge.payment_attributes)
    payment.succeeded?
  end
  
  def unpurchase_tickets
    payment.tickets.each(&:waiting!)
  end
  
  def on_failure
    unpurchase_tickets
  end
end