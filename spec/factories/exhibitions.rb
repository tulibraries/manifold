# frozen_string_literal: true

FactoryBot.define do
  factory :exhibition do
    title { "Salvador Dali" }
    description { ActionText::Content.new("Hello World") }
    start_date { "2019-01-16" }
    end_date { "2019-01-16" }
    promoted_to_events { false }
    online_url { "" }

    trait :with_image do
      after :create do |exhibition|
        exhibition.images.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
