class PaymentPolicy
  
  attr_reader :user, :record
  
  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def refund?
    user.admin?
  end
end