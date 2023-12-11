# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Conquerors #{n}" }
    description { ActionText::Content.new("Hello World") }
    group_type { "Department" }
    persons { [ FactoryBot.create(:person) ] }
    chair_dept_heads { [ FactoryBot.create(:person) ] }
    space { }

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

    trait :no_chair_dept_heads do
      chair_dept_heads { [] }
    end
  end
end
