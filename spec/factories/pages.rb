# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    title { "MyString" }
    description { "MyText" }
    layout { "MyLayout" }
    trait :with_document do
      after :create do |page|
        file_path = Rails.root.join("spec", "support", "assets", "hal.png")
        file = fixture_file_upload(file_path, "image/png")
        page.document.attach(file)
      end
    end
  end
end
