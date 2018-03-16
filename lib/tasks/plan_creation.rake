namespace :theater do
  
  task create_plans: :environment do
    plans = [
      {remote_id: "orchestra_monthly", product: {name: "Orchestra Monthly"},
       nickname: "Orchestra Monthly", price_cents: 10_000, interval: "month",
       interval_count: 1, tickets_allowed: 1, ticket_category: "Orchestra"},
      {remote_id: "balcony_monthly", product: {name: "Balcony Monthly"},
       nickname: "Balcony Monthly", price_cents: 60_000, interval: "month",
       interval_count: 1, tickets_allowed: 1, ticket_category: "Balcony"},
      {remote_id: "vip_monthly", product: {name: "VIP Monthly"},
       nickname: "VIP Monthly", price_cents: 30_000, interval: "month",
       interval_count: 1, tickets_allowed: 1, ticket_category: "VIP"}
    ]
    Plan.transaction do
      plans.each { |plan_data| CreatesPlan.new(**plan_data).run }
    end
  end
end