FactoryBot.define do
  factory :plan do
    remote_id "MyString"
    nickname "MyString"
    price_cents 10_000
    interval 2
    interval_count 1
    tickets_allowed 1
    ticket_category "MyString"
    status 1
    description "MyText"
  end
end
