class Address < ApplicationRecord
  
  validates :address_1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  
  def all_fields
    [address_1, address_2, city, state, zip].compact.join(", ")
  end
end