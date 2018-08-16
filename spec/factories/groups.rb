FactoryBot.define do
  factory :group do
    name { "Conquerors" }
    description { "Able bodied men and women of adventure" }
    phone_number { "2155551213" }
    email_address { "we@example.com" }
    group_type { "Department" }
    # Add related objects in create.
    # e.g.
    #   let(:building) { FactoryBot.create(:building) }
    #   let(:space) { FactoryBot.create(:space, building: building) }
    #   let(:person) { FactoryBot.create(:person, buildings: [building], spaces: [space]) }
    #   let(:group) { FactoryBot.create(:group, persons: [person], buildings: [building], spaces: [space]) }
  end
end
