# frozen_string_literal: true

FactoryBot.define do
  factory :person do
    first_name { "Zaphod" }
    sequence(:last_name) { |n| "Beeblebrox #{n}" }
    phone_number { "2155551213" }
    sequence(:email_address) { |n| "zbeeblebrox-#{n}@example.com" }
    chat_handle { "zbeeblebrox" }
    job_title { "President of the Galaxy" }
    research_identifier { "PREZBEEB" }
    personal_site { "http://prez.example.com" }
    springshare_id { "0123-4567-8901" }
    libguides_account { "0123-4567-8901" }
    spaces { [FactoryBot.create(:space)] }
    sequence(:specialties) { |n| [ "Subject #{n}" ] }
    trait :with_image do
      after :create do |person|
        file_path = Rails.root.join("spec", "support", "assets", "hal.png")
        file = fixture_file_upload(file_path, "image/png")
        person.image.attach(file)
      end
    end
  end
end
