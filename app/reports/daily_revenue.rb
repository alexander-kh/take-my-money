class DailyRevenue
  
  include Reportable
  
  attr_accessor :date, :payments
  
  def self.find_collection
    Payment.includes(payment_line_items: :buyable).all.group_by(&:date).
      map do |date, payments|
        DailyRevenue.new(date, payments)
    end
  end
  
  def initialize(date, payments)
    @date = date
    @payments = payments
  end
  
  def revenue
    payments.sum(&:price)
  end
  
  def discounts
    payments.sum(&:discount)
  end
  
  def tickets_sold
    payments.flat_map(&:tickets).size
  end
  
  columns do
    column(:date)
    column(:tickets_sold)
    column(:revenue)
    column(:discounts)
  end
end