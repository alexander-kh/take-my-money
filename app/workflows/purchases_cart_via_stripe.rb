class PurchasesCartViaStripe < PurchasesCart
  
  attr_accessor :stripe_token, :stripe_charge
  
  def initialize(user:, stripe_token:, purchase_amount_cents:)
    super(user: user, purchase_amount_cents: purchase_amount_cents)
    @stripe_token = stripe_token
  end
  
  def update_tickets
    tickets.each(&:purchased!)
  end
  
  def purchase
    @stripe_charge = StripeCharge.charge(token: stripe_token, payment: payment)
    payment.update!(
      status: @stripe_charge.status, response_id: @stripe_charge.id,
      full_response: @stripe_charge.to_json)
  end
  
  def payment_attributes
    super.merge(payment_method: "stripe")
  end
end