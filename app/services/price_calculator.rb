class PriceCalculator
  
  attr_accessor :tickets, :discount_code
  
  def initialize(tickets = [], discount_code = nil)
    @tickets = tickets
    @discount_code = discount_code || NullDiscountCode.new
  end
  
  def subtotal
    tickets.map(&:price).sum
  end
  
  def total_price
    discount_code.apply_to(subtotal)
  end
  
  def discount
    discount_code.discount_for(subtotal)
  end
end