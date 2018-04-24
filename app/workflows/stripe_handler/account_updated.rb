module StripeHandler
  
  class AccountUpdated
    
    attr_accessor :event, :success
    
    def initialize(event)
      @event = event
      @success = false
    end
    
    def account
      event.data.object
    end
    
    def affiliate
      Affiliate.find_by(stripe_id: account.id)
    end
    
    def run
      stripe_account = StripeAccount.new(affiliate, account: account)
      result = stripe_account.update_affiliate_verification
      @success = result
    end
  end
end