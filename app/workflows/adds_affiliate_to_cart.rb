class AddsAffiliateToCart
  
  attr_accessor :user, :tag
  
  def initialize(user:, tag:)
    @user = user
    @tag = tag&.downcase
  end
  
  def affiliate
    return nil if tag.blank?
    @affiliate ||= Affiliate.find_by(tag: tag)
  end
  
  def shopping_cart
    @shopping_cart ||= ShoppingCart.for(user: user)
  end
  
  def affiliate_belongs_to_user?
    return true unless affiliate
    return true unless user
    affiliate&.user == user
  end
  
  def run
    return unless user
    return if affiliate_belongs_to_user?
    shopping_cart.update(affiliate: affiliate)
  end
end