class DayRevenueReport < SimpleDelegator
  
  include Reportable
  
  def self.find_collection
    result = DayRevenue.all.map { |dr| DayRevenueReport.new(dr) }
    result << DayRevenueReport.new(DayRevenue.build_for(Date.yesterday))
    result << DayRevenueReport.new(DayRevenue.build_for(Date.current))
    result.sort_by(&:day)
  end
  
  def initialize(day_revenue)
    super(day_revenue)
  end
  
  columns do
    column(:day)
    column(:price)
    column(:discounts)
    column(:ticket_count)
  end
end