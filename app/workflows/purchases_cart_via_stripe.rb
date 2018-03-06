class PurchasesCartViaStripe < PurchasesCart
  
  attr_accessor :stripe_token, :stripe_charge
  
  def initialize(user:, stripe_token:, purchase_amount_cents:,
    expected_ticket_ids:)
    super(user: user, purchase_amount_cents: purchase_amount_cents,
      expected_ticket_ids: expected_ticket_ids)
    @stripe_token = stripe_token
  end
  
  def update_tickets
    tickets.each(&:purchased!)
  end
  
  def purchase
    return unless @continue
    @stripe_charge = StripeCharge.new(token: stripe_token, payment: payment)
    @stripe_charge.charge
    payment.update!(@stripe_charge.payment_attributes)
    reverse_purchase if payment.failed?
  end
  
  def payment_attributes
    super.merge(payment_method: "stripe")
  end
end