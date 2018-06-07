FactoryBot.define do
  factory :person do
    first_name "Zaphod"
    last_name "Beeblebrox"
    phone_number "2155551213"
    email_address "zbeeblebrox@example.com"
    chat_handle "zbeeblebrox"
    job_title "President of the Galaxy"
    identifier "PREZBEEB"
    factory :person_with_buildings do
      after(:create) do |person|
        create(:building, person: person)
      end
    end
    factory :person_with_spaces do
      after(:create) do |person|
        create(:space, person: person)
      end
    end
  end
end
