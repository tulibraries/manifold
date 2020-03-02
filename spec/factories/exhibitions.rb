# frozen_string_literal: true

FactoryBot.define do
  factory :exhibition do
    title { "MyString" }
    description { "MyText" }
    start_date { "2019-01-16" }
    end_date { "2019-01-16" }

    trait :with_image do
      after :create do |exhibition|
        file_path = Rails.root.join("spec/fixtures/charles.jpg")
        file = fixture_file_upload(file_path, "image/png")
        exhibition.image.attach(file)
      end
    end
    promoted_to_events { false }
  end
end
