class ChargeSetupValidityException < StandardError
  
  attr_accessor :message, :user, :expected_purchase_cents, :expected_ticket_ids
  
  def initialization(message = nil,
      user:, expected_purchase_cents:, expected_ticket_ids:)
    super(message)
    @user = user
    @expected_purchase_cents = expected_purchase_cents
    @expected_ticket_ids = expected_ticket_ids
  end
end