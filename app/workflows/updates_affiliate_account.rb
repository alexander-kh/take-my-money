class UpdatesAffiliateAccount
  
  attr_accessor :affiliate, :user, :params, :success
  
  def initialize(affiliate:, user:, params:)
    @affiliate = affiliate
    @user = user
    @params = params
    @success = false
  end
  
  def affiliate_belongs_to_user?
    return true unless affiliate
    return true unless user
    affiliate&.user == user
  end
  
  def stripe_account
    @stripe_account ||= StripeAccount.new(affiliate)
  end
  
  def run
    Affiliate.transaction do
      return if user.nil? || affiliate.nil?
      return unless affiliate_belongs_to_user?
      stripe_account.update(params)
      @success = true
    end
  end
  
  def success?
    @success
  end
end