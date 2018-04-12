class DiscountCode < ApplicationRecord
  
  has_paper_trail
  
  monetize :minimum_amount_cents
  monetize :maximum_discount_cents
  
  def percentage_float
    percentage * 1.0 / 100
  end
  
  def multiplier
    1 - percentage_float
  end
  
  def apply_to(subtotal)
    subtotal - discount_for(subtotal)
  end
  
  def discount_for(subtotal)
    return Money.zero unless applies_to_total?(subtotal)
    result = subtotal * percentage_float
    result = [result, maximum_discount].min if maximum_discount?
    result
  end
  
  def maximum_discount?
    maximum_discount_cents.present? && maximum_discount > Money.zero
  end
  
  def applies_to_total?(subtotal)
    return true if minimum_amount_cents.nil?
    subtotal >= minimum_amount
  end
end
