FactoryBot.define do
  factory :subscription do
    user nil
    plan nil
    start_date "2018-03-10"
    end_date "2018-03-10"
    status 1
    payment_method "MyString"
    remote_id "MyString"
  end
end
