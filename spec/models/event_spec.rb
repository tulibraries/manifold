# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

  context "Required Fields" do
    skip "Required fields are TBD"
    required_fields = []
    required_fields.each do |f|
      example "missing #{f} fields" do
        event = FactoryBot.build(:event)
        event[f] = ""
        expect { event.save! }.to raise_error(/#{f.humanize(capitalize: true)} can't be blank/)
      end
    end
  end

  describe "past event video" do
    let(:ensemble_id) { "12345ABCDEF09876ZYXWVU" }
    example "Can set an ensemble ID" do
      event = FactoryBot.create(:event)
      event.ensemble_identifier = ensemble_id
      event.save
      expect(event.ensemble_identifier).to match(/#{ensemble_id}/)
    end
  end

  describe "has associations" do
    let(:event) { FactoryBot.create(:event, building: building, space: space, person: person) }
    example "building" do
      expect(event.building.name).to match(/#{Building.last.name}/)
    end
    example "space" do
      expect(event.space.name).to match(/#{Space.last.name}/)
    end
    example "person" do
      expect(event.person.last_name).to match(/#{Person.last.last_name}/)
    end
  end
end
