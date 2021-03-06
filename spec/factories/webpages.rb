# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "MyString" }
    description { "MyText" }
    layout { "None" }
    trait :with_file do
      after :create do |webpage|
        file = FactoryBot.create(:file_upload)
        webpage.file_uploads << file
      end
    end
    trait :with_files do
      after :create do |webpage|
        file = FactoryBot.create(:file_upload)
        file2 = FactoryBot.create(:file_upload)
        webpage.file_uploads << file
        webpage.file_uploads << file2
      end
    end
  end
end
