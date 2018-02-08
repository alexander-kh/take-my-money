class Ticket < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :performance
  has_one :event, through: :performance
  
  monetize :price_cents
  
  enum status: {unsold: 0, waiting: 1}
  enum access: {general: 0}
end
