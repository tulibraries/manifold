# frozen_string_literal: true

require "rails_helper"

RSpec.describe Event, type: :model do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building:) }
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
    let(:event) { FactoryBot.create(:event, building:, space:, person:) }
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
      event = FactoryBot.create(:event, building: nil, space: nil, person:)
      expect(event.get_date).to match(/\w+ \d+\, \d\d\d\d/)
    end
  end

  describe "set times" do
    let(:start_time) { Time.zone.parse "7/4/18 10:00 am" }
    let(:start_date) { Time.zone.parse "7/4/18" }
    let(:end_date) { Time.zone.parse "7/4/18" }
    let(:end_time) { Time.zone.parse "7/4/18 2:00 pm" }
    example "event is all day long" do
      event = FactoryBot.create(:event, building:, space:, person:, start_time: start_date, all_day: true)
      expect(event.set_times).to match("(All day)")
    end
    example "event has an start and end time" do
      event = FactoryBot.create(:event, building:, space:, person:, start_time:, end_time:, all_day: false)
      expect(event.set_times).to match("10:00 am -  2:00 pm")
    end
    example "empty start_date does not error" do
      event = FactoryBot.create(:event, building:, space:, person:, start_time: nil, end_time:, all_day: false)
      expect(event.set_start_time).to match("")
    end
    example "empty end_date does not error" do
      event = FactoryBot.create(:event, building:, space:, person:, start_time:, end_time: nil, all_day: false)
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
      location_name: ["The Text 1", "The Text 2"],
      location_space: ["The Text 1", "The Text 2"],
      address: ["The Text 1", "The Text 2"],
      city: ["The Text 1", "The Text 2"],
      state: ["The Text 1", "The Text 2"],
      zip: ["The Text 1", "The Text 2"],
      contact_name: ["The Text 1", "The Text 2"],
      contact_email: ["The Text 1", "The Text 2"],
      contact_phone: ["The Text 1", "The Text 2"],
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
        next if k == :description # Description is not versionable
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
        event = FactoryBot.create(:event, building:)
        input = event.map_to_schema_dot_org
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq building.name
      end

      example "Location is text fallback location" do
        event = FactoryBot.create(:event)
        input = event.map_to_schema_dot_org
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq event[:location_name]
        expect(input["location"]["address"]["@type"]).to eq "PostalAddress"
        expect(input["location"]["address"]["streetAddress"]).to eq event[:address]
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

  describe "internal building" do
    it "resolves from the associated building record" do
      building = FactoryBot.create(
        :building,
        name: "Charles L. Blockson Afro-American Collection",
        address1: "1330 Polett Walk",
        city: "Philadelphia",
        state: "PA",
        zipcode: "19122"
      )
      event = FactoryBot.create(:event, building:, address: "Other address")

      expect(event.internal_building).to eq(building)
      expect(event.has_internal_building?).to be(true)
      expect(event.building_address1).to eq("1330 Polett Walk")
    end

    it "does not infer a building from the location name when building_id is blank" do
      FactoryBot.create(:building, name: "Charles L. Blockson Afro-American Collection")
      event = FactoryBot.create(
        :event,
        building: nil,
        location_name: "Charles L. Blockson Afro-American Collection"
      )

      expect(event.internal_building).to be_nil
      expect(event.has_internal_building?).to be(false)
    end
  end

  describe "location display methods" do
    context "external event (no internal building)" do
      let(:event) do
        FactoryBot.create(
          :event,
          building: nil,
          location_name: "Off-site venue",
          address: "123 Main St",
          city: "Anytown",
          state: "PA",
          zip: "19122"
        )
      end

      it "builds a google maps query from the raw location fields" do
        expect(event.google_maps_query).to eq("Off-site venue, 123 Main St, Anytown, PA, 19122")
      end

      it "assembles address lines from address and city/state/zip" do
        expect(event.location_address_lines).to eq(["123 Main St", "Anytown, PA, 19122"])
      end

      it "joins city/state/zip for building_address2" do
        expect(event.building_address2).to eq("Anytown, PA, 19122")
      end
    end

    context "internal building event" do
      let(:building) { FactoryBot.create(:building, address1: "1250 Polett Walk") }
      let(:event) { FactoryBot.create(:event, building:, address: "ignored raw address") }

      it "sources the address lines from the building, not the raw columns" do
        expect(event.building_address1).to eq("1250 Polett Walk")
        expect(event.location_address_lines.first).to eq("1250 Polett Walk")
      end
    end

    it "returns nil google_maps_query when all location fields are blank" do
      event = FactoryBot.create(:event, building: nil, location_name: "", address: "", city: "", state: "", zip: "")

      expect(event.google_maps_query).to be_nil
    end
  end

  describe "workshop / event filters" do
    it "treats a LibCal 'Workshop' category as a workshop (additive)" do
      event = FactoryBot.create(:event, event_type: "", tags: "", libcal_categories: "Workshop")

      expect(Event.is_workshop).to include(event)
      expect(Event.is_not_workshop).not_to include(event)
    end

    it "still treats a legacy tagged workshop as a workshop" do
      event = FactoryBot.create(:event, event_type: "", tags: "Workshop", libcal_categories: nil)

      expect(Event.is_workshop).to include(event)
    end

    it "does not treat a non-workshop LibCal event as a workshop" do
      event = FactoryBot.create(:event, event_type: "", tags: "", libcal_categories: "Event")

      expect(Event.is_workshop).not_to include(event)
      expect(Event.is_not_workshop).to include(event)
    end

    it "includes a non-workshop event with a NULL event_type in is_not_workshop" do
      event = FactoryBot.create(:event, event_type: nil, tags: nil, libcal_categories: nil)

      expect(Event.is_workshop).not_to include(event)
      expect(Event.is_not_workshop).to include(event)
    end

    it "routes a LibCal 'Digital Scholarship' category into is_dss_event" do
      event = FactoryBot.create(:event, tags: "", libcal_categories: "Digital Scholarship")

      expect(Event.is_dss_event).to include(event)
    end
  end

  it_behaves_like "categorizable"
  it_behaves_like "imageable"
  it_behaves_like "SchemaDotOrgable"
end
