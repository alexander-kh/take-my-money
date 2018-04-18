class AddsDiscountCodeToCart
  
  attr_accessor :user, :code
  
  def initialize(user:, code:)
    @user = user
    @code = code
    @success = false
  end
  
  def shopping_cart
    @shopping_cart ||= ShoppingCart.for(user: user)
  end
  
  def discount_code
    @discount_code ||= DiscountCode.find_by(code: code)
  end
  
  def run
    @success = shopping_cart.update(discount_code: discount_code)
  end
  
  def success?
    @success
  end
end