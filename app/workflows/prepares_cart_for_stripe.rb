class PreparesCartForStripe < PreparesCart
  
  attr_accessor :stripe_token, :stripe_charge
  
  def initialize(user:, stripe_token:, purchase_amount_cents:,
      expected_ticket_ids:, payment_reference: nil, shopping_cart:)
    super(user: user, purchase_amount_cents: purchase_amount_cents,
      expected_ticket_ids: expected_ticket_ids,
      payment_reference: payment_reference,
      shopping_cart: shopping_cart)
    @stripe_token = stripe_token
  end
  
  def update_tickets
    tickets.each(&:purchased!)
  end
  
  def on_success
    ExecutesStripePaymentJob.perform_later(payment, stripe_token.id)
  end
  
  def payment_attributes
    result = super.merge(payment_method: "stripe")
    if shopping_cart.affiliate
      result = result.merge(
        affiliate_id: shopping_cart.affiliate.id,
        affiliate_payment_cents: price_calculator.affiliate_payment.cents)
    end
    result
  end
end