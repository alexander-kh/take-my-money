class Subscription < ApplicationRecord
  
  belongs_to :user
  belongs_to :plan
  
  enum status: {active: 0, inactive: 1,
                waiting: 2, pending_initial_payment: 3,
                canceled: 4}
  
  delegate :name, to: :plan
  
  def make_stripe_payment(stripe_customer)
    update!(
      payment_method: :stripe, status: :pending_initial_payment,
      remote_id: stripe_customer.find_subscription_for(plan))
  end
  
  def remote_plan_id
    plan.remote_id
  end
  
  def update_end_date
    update!(end_date: plan.end_date_from)
  end
  
  def currently_active?
    active? && (end_date > Date.current)
  end
  
  def performance
  end
end
