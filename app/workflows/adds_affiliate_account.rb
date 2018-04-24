class AddsAffiliateAccount
  
  attr_accessor :user, :affiliate, :success, :tos_checked, :request_ip, :account
  
  def initialize(user:, tos_checked: nil, request_ip: nil)
    @user = user
    @tos_checked = tos_checked
    @request_ip = request_ip
    @success = false
  end
  
  def run
    Affiliate.transaction do
      @affiliate = Affiliate.create(
        user: user, country: "US",
        name: user.name, tag: Affiliate.generate_tag)
      @affiliate.update(stripe_id: acquire_stripe_id)
      account.update_affiliate_verification
    end
    @success = true
  end
  
  def acquire_stripe_id
    @account = StripeAccount.new(
      @affiliate, tos_checked: tos_checked, request_ip: request_ip)
    account.account.id
  end
  
  def success?
    @success
  end
end