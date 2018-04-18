class AddsShippingToCart
  
  attr_accessor :user, :address_fields, :method
  
  def initialize(user:, address:, method:)
    @user = user
    @address_fields = address
    @method = method
    @success = false
  end
  
  def shopping_cart
    @shopping_cart ||= ShoppingCart.for(user: user)
  end
  
  def run
    ShoppingCart.transaction do
      shopping_cart.create_address!(address_fields)
      shopping_cart.update!(shipping_method: method)
      @success = shopping_cart.valid?
    end
  rescue ActiveRecord::RecordInvalid
    @success = false
  end
  
  def success?
    @success
  end
end