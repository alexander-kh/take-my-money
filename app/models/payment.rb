class Payment < ApplicationRecord
  
  include HasReference
  
  belongs_to :user, optional: true
  has_many :payment_line_items
  has_many :tickets, through: :payment_line_items,
                     source_type: "Ticket", source: "buyable"
  
  monetize :price_cents
  
  enum status: [:created, :succeeded]
  
  def create_line_items(tickets)
    tickets.each do |ticket|
      payment_line_items.create!(
        buyable: ticket, price_cents: ticket.price.cents)
    end
  end
  
  def total_cost
    tickets.map(&:price).sum
  end
end
