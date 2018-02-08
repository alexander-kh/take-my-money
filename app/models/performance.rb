class Performance < ApplicationRecord
  belongs_to :event
  has_many :tickets
end
