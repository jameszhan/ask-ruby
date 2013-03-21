# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    name "MyString"
    description "MyString"
    count 1
    association :user
    association :node
  end
end
