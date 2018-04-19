class NotifiesTaxCloudOfRefund
  
  attr_accessor :payment
  
  def initialize(payment)
    @payment = payment
    @success = false
  end
  
  def tax_calculator
    @tax_calculator ||= payment.price_calculator.tax_calculator
  end
  
  def reference
    payment.original_payment&.reference || payment.reference
  end
  
  def run
    result = tax_calculator.refund(reference)
    @success = (result == "OK")
  end
end