# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    body "this is my body"
    association :user
    association :question
  end
end
