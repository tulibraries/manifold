# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "MyString" }
    description { "MyText" }
    layout { "MyLayout" }
    trait :with_file do
      after :create do |webpage|
        file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
        file = fixture_file_upload(file_path, "application/pdf")
        webpage.file_uploads.attach(file)
      end
    end
  end
end
