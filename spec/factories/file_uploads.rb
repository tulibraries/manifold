# frozen_string_literal: true

FactoryBot.define do
  factory :file_upload do
    sequence(:name) { |n| "File #{n}" }
    file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
    file { Rack::Test::UploadedFile.new(file_path, "application/pdf") }
    trait :with_image do
      after :create do |upload|
        upload.image.attach(io:
          File.open(Rails.root.join("spec/fixtures/charles.jpg")),
          filename: "charles.jpg",
          content_type: "image/jpeg")
      end
    end
  end
end
