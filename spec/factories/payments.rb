FactoryBot.define do
  factory :payment do
    user nil
    price 100
    status 1
    reference "MyString"
    payment_method "MyString"
    response_id "MyString"
    full_response ""
  end
end
