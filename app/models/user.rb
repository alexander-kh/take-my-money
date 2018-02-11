class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :tickets
  
  def tickets_in_cart
    tickets.waiting.all.to_a
  end
end
