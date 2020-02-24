# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Conquerors #{n}" }
    description { "Able bodied men and women of adventure" }
    group_type { "Department" }
    persons { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    chair_dept_heads { [ FactoryBot.create(:person, spaces: [ FactoryBot.create(:space) ]) ] }
    space { FactoryBot.create(:space) }
  end
end
