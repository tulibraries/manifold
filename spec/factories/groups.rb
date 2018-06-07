FactoryBot.define do
  factory :group do
    name "Conquerors"
    description "Able bodied men and women of adventure"
    phone_number "2155551213"
    email_address "we@example.com"
    association :building
    association :space
    factory :group_with_persons do
      after(:create) { |group|
        create(:person,  group: group)
      }
    end
  end
end
