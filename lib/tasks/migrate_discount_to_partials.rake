namespace :snow_globe do
  task migrate_discounts: :environment do
    Payment.transaction do
      Payment.all.each do |payment|
        partials = {}
        if payment.discount_cents.positive?
          partials[:discount_cents] = -payment.discount_cents
        end
        partials[:ticket_cents] = payment.tickets.map(&:price_cents)
        payment.update(partials: partials)
      end
    end
  end
end