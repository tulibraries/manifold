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

  describe "can visit" do
    example "event is visitable" do
      event = FactoryBot.create(:event, building: building, space: space, person: person)
      expect(event.can_visit).to be
    end
    example "event is not visitable" do
      event = FactoryBot.create(:event, building: nil, space: nil, person: person)
      expect(event.can_visit).to_not be
    end
  end

  describe "get date" do
    example "event date renders as month day, year" do
      event = FactoryBot.create(:event, building: nil, space: nil, person: person)
      expect(event.get_date).to match(/\w+ \d+\, \d\d\d\d/)
    end
  end

  describe "set times" do
    let(:start_time) { "10:00 am" }
    let(:end_time) { "2:00 pm" }
    example "event is all day long", :skip do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: "(All day)")
      expect(event.set_times).to match(/^(All day)$/)
    end
    example "event has an start and end time" do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: start_time, end_time: end_time)
      expect(event.set_times).to match(/^10:00 AM - 02:00 PM$/)
    end
  end
end
