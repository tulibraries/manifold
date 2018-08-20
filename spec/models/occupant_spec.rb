require 'rails_helper'

RSpec.describe Occupant, type: :model do
  context "Group has space" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.build(:person, spaces: [space1]) }

    example "Create group with space" do
      expect(person.spaces).to include space1
      expect(person.spaces).to_not include space2
    end

    example "Assign group with different space" do
      person.spaces = [space2]
      expect(person.spaces).to_not include space1
      expect(person.spaces).to include space2
    end
  end

  context "Space has group" do
    let(:building) { FactoryBot.create(:building) }
    let(:space1) { FactoryBot.create(:space, building: building) }
    let(:space2) { FactoryBot.create(:space, building: building) }
    let(:person) { FactoryBot.create(:person, spaces: [space1]) }

    example "valid" do
      expect(space1.persons).to include person
    end

    example "Assign group to space" do
      expect(space2.persons).to_not include person
      space2.persons = [person]
      expect(space2.persons).to include person
    end
  end
end
