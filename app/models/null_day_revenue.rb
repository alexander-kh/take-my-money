class NullDayRevenue < DayRevenue
  
  attr_accessor :date, :ticket_count
  
  def initialize(date)
    @date = date
  end
  
  def day
    date
  end
  
  def price
    Money.new(0)
  end
  
  def discounts
    Money.new(0)
  end  
end