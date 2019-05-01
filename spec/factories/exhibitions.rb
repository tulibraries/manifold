# frozen_string_literal: true

FactoryBot.define do
  factory :exhibition do
    title { "MyString" }
    description { "MyText" }
    start_date { "2019-01-16" }
    end_date { "2019-01-16" }
    trait :with_image do
      after :create do |building|
        file_path = Rails.root.join("spec", "fixtures", "charles.jpg")
        file = fixture_file_upload(file_path, "image/png")
        building.image.attach(file)
      end
    end
  end
end
