# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :credit_card do
    user_id 1
    key "key"
    credit_card_number "credit_card_number"
  end
end
