FactoryBot.define do
  factory :person do
    first_name "Zaphod"
    last_name "Beeblebrox"
    phone_number "2155551213"
    email_address "zbeeblebrox@example.com"
    chat_handle "zbeeblebrox"
    job_title "President of the Galaxy"
    identifier "PREZBEEB"
    association :building
    space_id 0
    group_id 0
  end
end
