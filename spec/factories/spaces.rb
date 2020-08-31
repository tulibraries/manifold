# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :space do
    sequence(:name) { |n| "Room #{n}" }
    description { "Situation room where maps were consulted to track the project's progress" }
    accessibility { "Yes" }
    phone_number { "2155551213" }
    email { "mmuffley@example.com" }
    association :building

    factory :space_with_parent do
      after(:create) do |space|
        space.ancestry = "#{create(:space).id}"
      end
    end
    trait :with_image do
      after :create do |space|
        space.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
