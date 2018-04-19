class CreatesStripeRefund
  
  attr_accessor :payment_to_refund, :success, :stripe_refund
  
  def initialize(payment_to_refund:)
    @payment_to_refund = payment_to_refund
    @success = false
  end
  
  def run
    Payment.transaction do
      process_refund
      update_payment
      update_tickets
      on_success
    end
  rescue StandardError
    on_failure
  end
  
  def process_refund
    raise "No Such Payment" if payment_to_refund.nil?
    @stripe_refund = StripeRefund.new(payment_to_refund: payment_to_refund)
    @stripe_refund.refund
    raise "Refund failure" unless stripe_refund.success?
  end
  
  def update_payment
    payment_to_refund.update!(stripe_refund.refund_attributes)
    payment_to_refund.payment_line_items.each(&:refunded!)
    payment_to_refund.original_payment.refunded! if stripe_refund.success?
  end
  
  def update_tickets
    payment_to_refund.tickets.each(&:refund_successful)
  end
  
  def on_success
    RefundMailer.notify_success(payment_to_refund).deliver_later
    NotifyTaxCloudOfRefundJob.perform_later(payment_to_refund)
  end
  
  def on_failure
    unrefund_tickets
    RefundMailer.notify_failure(payment_to_refund).deliver_later
  end
  
  def unrefund_tickets
    payment_to_refund.tickets.each(&:purchased!)
  end
end