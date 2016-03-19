# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    login "login"
    hashed_password "hashed_password"
  end
end
