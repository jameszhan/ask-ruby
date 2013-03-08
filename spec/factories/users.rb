# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do    
    name     "User"
    sequence(:email){ |n| "email#{n}@askrubyist.com" }
    password "12345678"
    password_confirmation "12345678"
    roles [:member]
  end
end
