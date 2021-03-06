# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Conquerors #{n}" }
    description { "Able bodied men and women of adventure" }
    group_type { "Department" }
    persons { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    chair_dept_heads { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    space { FactoryBot.create(:space) }

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
