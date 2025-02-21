# frozen_string_literal: true

FactoryBot.define do
  factory :external_link do
    title { "MyString" }
    link { "https://example.org" }

    trait :with_image do
      after :create do |external_link|
        external_link.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end

    factory :external_link_internal_path do
      title { "Internal Path" }
      link { "/path/to/thing" }
    end
  end
end
