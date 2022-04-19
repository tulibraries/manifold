# frozen_string_literal: true

require "rails_helper"

RSpec.describe Occupant, type: :model do
  context "Person has building" do
    let(:building) { FactoryBot.create(:building) }
    let(:building1) { FactoryBot.create(:building) }
    let(:person) { FactoryBot.build(:person, buildings: [building]) }

    example "Create person with building" do
      expect(person.buildings).to include building
      expect(person.buildings).to_not include building1
    end

    example "Assign group with different building" do
      person.buildings = [building1]
      expect(person.buildings).to_not include building
      expect(person.buildings).to include building1
    end
  end

  context "Building has person" do
    let(:building) { FactoryBot.create(:building) }
    let(:building1) { FactoryBot.create(:building) }
    let(:person) { FactoryBot.create(:person, buildings: [building]) }

    example "valid" do
      expect(building.persons).to include person
    end

    example "Assign group to building" do
      expect(building1.persons).to_not include person
      building1.persons = [person]
      expect(building1.persons).to include person
    end
  end
end
