# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title 'title'
    body 'body is too short!'
    association :user
  end
  
  factory :another_question, class: Question do
    title "Another Question with User admin"
    body "Another Question with User admin"
    association :user, factory: :admin
  end
  
end
