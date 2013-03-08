# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title 'title'
    body 'body is too short!'
    association :user
  end
end
