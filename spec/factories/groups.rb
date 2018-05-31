FactoryBot.define do
  factory :group do
    name "Conquerors"
    description "Able bodied men and women of adventure"
    phone_number "2155551213"
    email_address "we@example.com"
    association :building
    association :space
    association :person
  end
end
