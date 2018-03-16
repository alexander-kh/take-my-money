module StripeHandler
  
  class CustomerSubscriptionDeleted
    
    attr_accessor :event, :success, :payment
    
    def initialize(event)
      @event = event
      @success = false
    end
    
    def remote_subscription
      @event.data.object
    end
    
    def subscription
      @subscription ||= Subscription.find_by(remote_id: remote_subscription.id)
    end
    
    def run
      subscription&.canceled!
    end
  end
end