# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Conquerors #{n}" }
    description { "Able bodied men and women of adventure" }
    group_type { "Department" }
    persons { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    chair_dept_heads { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    space { FactoryBot.create(:space) }
    trait :with_document do
      after :create do |groups|
        file_path = Rails.root.join("spec", "support", "assets", "hal.png")
        file = fixture_file_upload(file_path, "image/png")
        groups.documents.attach(file)
      end
    end
  end
end
