class PaymentLineItem < ApplicationRecord
  belongs_to :payment
  belongs_to :buyable, polymorphic: true
  
  monetize :price_cents
end
