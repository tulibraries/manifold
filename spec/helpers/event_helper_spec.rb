# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventHelper, type: :helper do
  context "JSON-LD" do
    describe "Common fields" do
      let(:event) { FactoryBot.create(:event) }
      subject { JSON.parse(json_ld(event)) }

      it "has common values" do
        expect(subject["@context"]).to eq "http://schema.org"
        expect(subject["@type"]).to eq "Event"
        expect(subject["name"]).to eq event[:title]
        expect(subject["description"]).to eq event[:description]
      end
    end
    describe "Location" do
      example "campus building" do
        building = FactoryBot.create(:building)
        event = FactoryBot.create(:event, building: building)
        input = JSON.parse(json_ld(event))
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq building.name
      end

      example "Location is external building" do
        event = FactoryBot.create(:event)
        input = JSON.parse(json_ld(event))
        expect(input["location"]["@type"]).to eq "Place"
        expect(input["location"]["name"]).to eq event[:external_building]
        expect(input["location"]["address"]["@type"]).to eq "PostalAddress"
        expect(input["location"]["address"]["streetAddress"]).to eq event[:external_address]
        expect(input["location"]["address"]["addressRegion"]).to eq event[:external_state]
        expect(input["location"]["address"]["postalCode"]).to eq event[:external_zip]
      end
    end

    describe "timed event" do
      example "start and end time" do
        event = FactoryBot.create(:event)
        input = JSON.parse(json_ld(event))
        expect(DateTime.parse(input["startTime"])).to eq(event[:start_time])
        expect(DateTime.parse(input["endTime"])).to eq(event[:end_time])
        expect(input["all_day"]).to_not be
      end
      example "All day event" do
        event = FactoryBot.create(:event, start_time: nil, end_time: nil, all_day: true)
        input = JSON.parse(json_ld(event))
        expect(input["endTime"]).to be nil
        expect(input["startTime"]).to be nil
      end
    end
  end

  describe "Get Building Name" do
    context "receives string with translation" do
      it "renders the translation" do
        expect(helper.get_bldg_name("Sullivan Hall")).to include("Sullivan Hall - Blockson Collection")
      end
    end
    context "receives string without translation" do
      it "renders the default" do
        expect(helper.get_bldg_name("Kahn Hall")).to eq("Kahn Hall")
      end
    end
  end
end
