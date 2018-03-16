class ChangesStripeSubscriptionPlan
  
  attr_accessor :subscription_id, :user, :new_plan_id, :success
  
  def initialize(subscription_id:, user:, new_plan_id:)
    @subscription_id = subscription_id
    @user = user
    @new_plan_id = new_plan_id
    @success = false
  end
  
  def new_plan
    @plan ||= Plan.find_by(id: new_plan_id)
  end
  
  def subscription
    @subscription ||= Subscription.find_by(id: subscription_id)
  end
  
  def customer
    @customer ||= StripeCustomer.new(user)
  end
  
  def remote_subscription
    @remote_subscription ||=
      customer.subscriptions.retrieve(subscription.remote_id)
  end
  
  def user_is_subscribed?
    subscription_id && user.subscriptions.map(&:id).include?(subscription_id)
  end
  
  def run
    return unless user_is_subscribed?
    return if customer.nil? || remote_subscription.nil?
    remote_subscription.plan = new_plan.remote_id
    subscription.update(plan: new_plan)
    remote_subscription.save
    @success = true
  end
end