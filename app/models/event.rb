class Event < ApplicationRecord
  has_many :performances, dependent: :destroy
  accepts_nested_attributes_for :performances, allow_destroy: true
end
