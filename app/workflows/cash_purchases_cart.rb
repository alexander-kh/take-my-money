class CashPurchasesCart < PreparesCart
  
  def update_tickets
    tickets.each(&:purchased!)
  end
  
  def on_success
    @success = true
    tickets.each do |ticket|
      ticket.update(payment_reference: payment.reference)
    end
  end
  
  def payment_attributes
    super.merge(
      payment_method: "cash", status: "succeeded",
      administrator_id: user.id)
  end
  
  def pre_purchase_valid?
    raise UnathorizedPurchaseException.new(user: user) unless user.admin?
    true
  end
  
  def on_failure
    unpurchase_tickets
  end
end