class PreparesCartForPayPal < PreparesCart
  
  attr_accessor :pay_pal_payment
  
  def update_tickets
    tickets.each(&:pending!)
  end
  
  def redirect_on_success_url
    pay_pal_payment.redirect_url
  end
  
  def payment_attributes
    super.merge(payment_method: "paypal")
  end
  
  def calculate_success
    @success = payment.pending?
  end
  
  def on_success
    @pay_pal_payment = PayPalPayment.new(payment: payment)
    payment.update!(response_id: pay_pal_payment.response_id)
    tickets.each do |ticket|
      ticket.update(payment_reference: payment.reference)
    end
    payment.pending!
    unpurchase_tickets if payment.failed?
  end
end