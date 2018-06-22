FactoryBot.define do
  factory :person do
    first_name "Zaphod"
    last_name "Beeblebrox"
    phone_number "2155551213"
    email_address "zbeeblebrox@example.com"
    chat_handle "zbeeblebrox"
    job_title "President of the Galaxy"
    identifier "PREZBEEB"

    factory :person_with_groups do
      after(:create) do |person|
        create_list(:group, 1, persons: [person]) 
      end
    end

    factory :person_with_buildings do
      after(:create) do |person|
        create_list(:building_with_people, 1, persons: [person])
      end
    end

    factory :person_with_spaces do
      after(:create) do |person|
        create_list(:space, 1, persons: [person])
      end
    end
  end

end
