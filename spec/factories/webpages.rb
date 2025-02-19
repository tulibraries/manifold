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
        webpage.assign_attributes(external_link:)
        webpage.save
      end
    end
    # annual-reports
    trait :with_external_links do
      after :create do |webpage|
        link_with_image = FactoryBot.create(:external_link, :with_image, title: "Featured")
        link_without_image = FactoryBot.create(:external_link)
        external_links = [link_with_image, link_without_image]
        webpage.assign_attributes(external_links:)
      end
    end
    trait :with_links_and_files do
      after :create do |webpage|
        external_links = [FactoryBot.create(:external_link, title: "Not Featured")]
        file_uploads = [FactoryBot.create(:file_upload)]
        webpage.assign_attributes(external_links:)
        webpage.assign_attributes(file_uploads:)
      end
    end
    trait :with_file do
      after :create do |webpage|
        file = FactoryBot.create(:file_upload)
        webpage.assign_attributes(file_uploads: [file])
      end
    end
    trait :with_file_and_image do
      after :create do |webpage|
        file = FactoryBot.create(:file_upload, :with_image)
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
