class DayRevenue < ApplicationRecord
  
  monetize :price_cents
  monetize :discounts_cents
  
  def self.for_date(date)
    find_by(day: date) || build_for(date)
  end
  
  def self.build_for(date)
    revenue = ActiveRecord::Base.connection.select_all(
        %{SELECT date(created_at) as day,
        sum(price_cents) as price_cents,
        sum(discount_cents) as discounts_cents
        FROM "payments"
        WHERE "payments"."status" = 1
        GROUP BY date(created_at)
        HAVING date(created_at) = '#{date}'}).map do |data|
      DayRevenue.new(data)
    end
    revenue = revenue.first || NullDayRevenue.new(date)
    tickets = PaymentLineItem.tickets.no_refund.
      where("date(created_at) = ?", date).count
    revenue.ticket_count = tickets
    revenue
  end
end
