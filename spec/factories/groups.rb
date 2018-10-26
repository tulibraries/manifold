# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Conquerors #{n}" }
    description { "Able bodied men and women of adventure" }
    group_type { "Department" }
    # Add related objects in create.
    # e.g.
    #   let(:building) { FactoryBot.create(:building) }
    #   let(:space) { FactoryBot.create(:space, building: building) }
    #   let(:person) { FactoryBot.create(:person, buildings: [building], spaces: [space]) }
    #   let(:group) { FactoryBot.create(:group, persons: [person], buildings: [building], spaces: [space]) }
  end
end
