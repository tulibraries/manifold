# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    slug { "lecture" }
    sequence(:title) { |n| "Event #{n}" }
    description { "MyText" }
    start_time { "2018-09-24 11:32:13" }
    end_time { "2018-09-24 11:32:13" }
    building { nil }
    space { nil }
    external_building { "Off-site building" }
    external_space { "Off-site space" }
    external_address { "123 Main St" }
    external_city { "Anytown" }
    external_state { "PA" }
    external_zip { "19122" }
    person { nil }
    external_contact_name { "Dirk Gently" }
    external_contact_email { "dirk@example.com" }
    external_contact_phone { "2155551212" }
    cancelled { false }
    registration_status { false }
    registration_link { "MyString" }
    content_hash { "MyString" }
    ensemble_identifier { "MyString" }
    tags { "" }
    all_day { false }
    alt_text { "Charles Library" }
    trait :with_image do
      after :create do |event|
        file_path = Rails.root.join("spec/fixtures/charles.jpg")
        file = fixture_file_upload(file_path, "image/jpeg")
        event.image.attach(file)
      end
    end
  end
end
