class UnathorizedPurchaseException < StandardError
  
  attr_accessor :message, :user, :expected_purchase_cents, :expected_ticket_ids
  
  def initialize(message = nil, user:)
    super(message)
    @user = user
  end
end