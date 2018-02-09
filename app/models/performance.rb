class Performance < ApplicationRecord
  belongs_to :event
  has_many :tickets
  
  def unsold_tickets(count)
    tickets.where(status: "unsold").limit(count)
  end
end
