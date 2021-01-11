# frozen_string_literal: true

FactoryBot.define do
  factory :file_upload do
    sequence(:name) { |n| "Service #{n}" }
    file_path = Rails.root.join("spec/fixtures/guidelines.pdf")
    file { Rack::Test::UploadedFile.new(file_path, "application/pdf") }
  end
end
