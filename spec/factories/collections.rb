# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    sequence(:name) { |n| "Collection #{ n }" }
    description { ActionText::Content.new("Hello World") }
    subject { ["MyText"] }
    contents { "MyText" }
    slug { "blockson" }

    categories { [] }

    association :space

    trait :with_image do
      after :create do |collection|
        collection.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
