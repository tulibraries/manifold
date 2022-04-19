# frozen_string_literal: true

FactoryBot.define do
  factory :webpage do
    title { "This is a Webpage" }
    description { ActionText::Content.new("Hello World") }
    layout { "None" }
    virtual_tour { "" }
    trait :as_scop do
      after :create do |webpage|
        webpage.assign_attributes(slug: "scop-intro")
      end
    end
    trait :with_external_link do
      after :create do |webpage|
        external_link = FactoryBot.create(:external_link)
        webpage.assign_attributes(external_link: external_link)
      end
    end
    trait :with_file do
      after :create do |webpage|
        file = FactoryBot.create(:file_upload)
        webpage.assign_attributes(file_uploads: [file])
      end
    end
    trait :with_files do
      after :create do |webpage|
        file1 = FactoryBot.create(:file_upload)
        file2 = FactoryBot.create(:file_upload)
        webpage.assign_attributes(file_uploads: [file1, file2])
      end
    end
  end
end
