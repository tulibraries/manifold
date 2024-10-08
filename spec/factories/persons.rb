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
    libguides_account { "1098-7654-3210" }
    buildings { [FactoryBot.create(:building)] }
    pronouns { "He/Him/His" }

    trait :with_subjects do
      subjects { build_list :subject, 3 }
    end

    trait :in_department do
      groups { build_list :group, 1 }
    end

    trait :with_image do
      after :create do |person|
        person.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
