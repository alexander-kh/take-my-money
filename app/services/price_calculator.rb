class PriceCalculator
  
  attr_accessor :tickets, :discount_code, :shipping
  
  def initialize(tickets = [], discount_code = nil, shipping = :none)
    @tickets = tickets
    @discount_code = discount_code || NullDiscountCode.new
    @shipping = shipping
  end
  
  def processing_fee
    (subtotal - discount).positive? ? Money.new(100) : Money.zero
  end
  
  def shipping_fee
    case shipping.to_sym
    when :standard then Money.new(200)
    when :overnight then Money.new(1000)
    else
      Money.zero
    end
  end
  
  def subtotal
    tickets.map(&:price).sum
  end
  
  def breakdown
    result = {ticket_cents: tickets.map { |t| t.price.cents }}
    if processing_fee.nonzero?
      result[:processing_fee_cents] = processing_fee.cents
    end
    result[:discount_cents] = -discount.cents if discount.nonzero?
    result[:shipping_cents] = shipping_fee.cents if shipping_fee.nonzero?
    result
  end
  
  def total_price
    subtotal - discount + processing_fee + shipping_fee
    # discount_code.apply_to(subtotal)
  end
  
  def discount
    discount_code.discount_for(subtotal)
  end
end