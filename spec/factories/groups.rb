FactoryBot.define do
  factory :group do
    name "Conquerors"
    description "Able bodied men and women of adventure"
    phone_number "2155551213"
    email_address "we@example.com"

    factory :group_with_people do
      after(:create) do |group|
        create_list(:person, 1, groups: [group]) 
      end
    end

    factory :group_with_buildings do
      after(:create) do |group|
        create_list(:building, 1, groups: [group])
      end
    end

    factory :group_with_spaces do
      after(:create) do |group|
        create_list(:space, 1, groups: [group])
      end
    end
  end
end
