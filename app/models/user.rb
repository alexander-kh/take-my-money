class User < ApplicationRecord
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  enum role: {user: 0, vip: 1, admin: 2}
  
  has_many :tickets
  has_many :subscriptions
  
  def tickets_in_cart
    tickets.waiting.all.to_a
  end
  
  def subscriptions_in_cart
    subscriptions.waiting.all.to_a
  end
end
