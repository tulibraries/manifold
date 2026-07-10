# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    slug { "lecture" }
    sequence(:title) { |n| "Event #{n}" }
    description { ActionText::Content.new("Hello World") }
    start_time { "2018-09-24 11:32:13" }
    end_time { "2018-09-24 11:32:13" }
    building { nil }
    space { nil }
    location_name { "Off-site building" }
    location_space { "Off-site space" }
    address { "123 Main St" }
    city { "Anytown" }
    state { "PA" }
    zip { "19122" }
    person { nil }
    contact_name { "Dirk Gently" }
    contact_email { "dirk@example.com" }
    contact_phone { "2155551212" }
    cancelled { false }
    registration_status { false }
    registration_link { "MyString" }
    content_hash { "MyString" }
    ensemble_identifier { "MyString" }
    tags { "" }
    event_type { "" }
    all_day { false }
    alt_text { "Charles Library" }
    suppress { false }
    trait :with_image do
      after :create do |event|
        event.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
