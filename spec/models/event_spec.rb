# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, buildings: [building]) }

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

  describe "get date" do
    example "event date renders as month day, year" do
      event = FactoryBot.create(:event, building: nil, space: nil, person: person)
      expect(event.get_date).to match(/\w+ \d+\, \d\d\d\d/)
    end
  end

  describe "set times" do
    let(:start_time) { Time.zone.parse "7/4/18 10:00 am" }
    let(:start_date) { Time.zone.parse "7/4/18" }
    let(:end_date) { Time.zone.parse "7/4/18" }
    let(:end_time) { Time.zone.parse "7/4/18 2:00 pm" }
    example "event is all day long" do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: start_date, all_day: true)
      expect(event.set_times).to match("(All day)")
    end
    example "event has an start and end time" do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: start_time, end_time: end_time, all_day: false)
      expect(event.set_times).to match("10:00 am -  2:00 pm")
    end
    example "empty start_date does not error" do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: nil, end_time: end_time, all_day: false)
      expect(event.set_start_time).to match("")
    end
    example "empty end_date does not error" do
      event = FactoryBot.create(:event, building: building, space: space, person: person, start_time: start_time, end_time: nil, all_day: false)
      expect(event.set_end_time).to match("")
    end
  end

  describe "all-day flag" do
    example "Is all day event", :focus do
      event = FactoryBot.create(:event, start_time: "1/1/2019", all_day: true)
      expect(event.all_day).to be
    end
    example "Is not all day event" do
      event = FactoryBot.create(:event, start_time: "1/1/2019", all_day: false)
      expect(event.all_day).to_not be
    end
  end

  describe "version all fields" do
    fields = {
      title: ["The Text 1", "The Text 2"],
      description: [ActionText::Content.new("Hello World"), ActionText::Content.new("Goodbye, Cruel World")],
      start_time: [Time.zone.parse("2018/9/24 11:00"), Time.zone.parse("2018/9/24 11:30")],
      end_time: [Time.zone.parse("2018/9/24 12:00"), Time.zone.parse("2018/9/24 12:30")],
      external_building: ["The Text 1", "The Text 2"],
      external_space: ["The Text 1", "The Text 2"],
      external_address: ["The Text 1", "The Text 2"],
      external_city: ["The Text 1", "The Text 2"],
      external_state: ["The Text 1", "The Text 2"],
      external_zip: ["The Text 1", "The Text 2"],
      external_contact_name: ["The Text 1", "The Text 2"],
      external_contact_email: ["The Text 1", "The Text 2"],
      external_contact_phone: ["The Text 1", "The Text 2"],
      cancelled: [false, true],
      registration_status: [true, false],
      registration_link: ["https://example.com/reg1", "https://example.com/reg2"],
      content_hash: ["The Text 1", "The Text 2"],
      alt_text: ["The Text 1", "The Text 2"],
      ensemble_identifier: ["The Text 1", "The Text 2"],
      tags: ["tag1, tag2", "tag3, tag4"],
      all_day: [false, true]
    }

    fields.each do |k, v|
      example "#{k} changes" do
        skip("description not versionable") if k == :description
        event = FactoryBot.create(:event, k => v.first)
        event.update(k => v.last)
        event.save!
        expect(event.versions.last.changeset[k]).to match_array(v)
      end
    end
  end

  describe "mapping to schema.org" do
    let(:event) { FactoryBot.create(:event) }

    it "has the expected type" do
      expect(event.map_to_schema_dot_org["@type"]).to eq "Event"
    end
    describe "Location" do
      example "campus building" do
        building = FactoryBot.create(:building)
        event = FactoryBot.create(:event, building: building)
        input = event.map_to_schema_dot_org
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq building.name
      end

      example "Location is external building" do
        event = FactoryBot.create(:event)
        input = event.map_to_schema_dot_org
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq event[:external_building]
        expect(input["location"]["address"]["@type"]).to eq "PostalAddress"
        expect(input["location"]["address"]["streetAddress"]).to eq event[:external_address]
      end
    end

    describe "timed event" do
      example "start and end time" do
        event = FactoryBot.create(:event)
        input = event.map_to_schema_dot_org
        expect(input["startDate"]).to eq(event[:start_time])
        expect(input["endDate"]).to eq(event[:end_time])
        expect(input["all_day"]).to_not be
      end
      example "All day event" do
        event = FactoryBot.create(:event, start_time: nil, end_time: nil, all_day: true)
        input = event.map_to_schema_dot_org
        expect(input["endTime"]).to be nil
        expect(input["startTime"]).to be nil
      end
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageable"
  it_behaves_like "SchemaDotOrgable"
end
