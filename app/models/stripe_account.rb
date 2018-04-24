class StripeAccount
  
  attr_accessor :affiliate, :account, :tos_checked, :request_ip
  
  def initialize(affiliate, tos_checked: false, request_ip: false, account: nil)
    @affiliate = affiliate
    @tos_checked = tos_checked
    @request_ip = request_ip
    @account = account
  end
  
  def account
    @account ||= begin
      if affiliate.stripe_id.blank?
        create_account
      else
        retreive_account
      end
    end
  end
  
  def update_affiliate_verification
    Affiliate.transaction do
      affiliate.update(
        stripe_charges_enabled: account.charges_enabled,
        stripe_transfers_enabled: account.payouts_enabled,
        stripe_disabled_reason: account.verification.disabled_reason,
        stripe_validation_due_by: account.verification.due_by,
        verification_needed: account.verification.fields_needed)
    end
  end
  
  def update(values)
    update_from_hash(account, values)
    self.account = account.save
    update_affiliate_verification
  end
  
  private
  
  def update_from_hash(object, values)
    values.each do |key, value|
      if value.is_a?(Hash)
        sub_object = object.send(key.to_sym)
        update_from_hash(sub_object, value)
      elsif value.present?
        object.send(:"#{key}=", value)
      end
    end
  end
  
  def create_account
    account_params = {country: affiliate.country, type: "custom"}
    if tos_checked
      account_params[:tos_acceptance] = {date: Time.now.to_i, ip: request_ip}
    end
    Stripe::Account.create(account_params)
  end
  
  def retreive_account
    Stripe::Account.retrieve(affiliate.stripe_id)
  end
end