class CreatesPlan
  
  attr_accessor :remote_id, :product, :nickname, :price_cents, :interval,
  :tickets_allowed, :ticket_category, :plan
  
  def initialize(remote_id:, product:, nickname:, price_cents:, interval:,
      interval_count:, tickets_allowed:, ticket_category:)
    @remote_id = remote_id
    @product = product
    @nickname = nickname
    @price_cents = price_cents
    @interval = interval
    @interval_count = interval_count
    @tickets_allowed = tickets_allowed
    @ticket_category = ticket_category
  end
  
  def run
    remote_plan = Stripe::Plan.create(
      id: remote_id, product: product, amount: price_cents, currency: "usd",
      interval: interval, interval_count: 1, nickname: nickname)
    self.plan = Plan.create(
      remote_id: remote_plan.id, nickname: nickname, price_cents: price_cents,
      interval: interval, interval_count: 1, tickets_allowed: tickets_allowed,
      ticket_category: ticket_category, status: :active)
  end
end