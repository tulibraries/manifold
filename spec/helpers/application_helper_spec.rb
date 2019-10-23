# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do


  describe "#menu_category_list" do
    context "With more than one category" do

      let(:category1) { FactoryBot.create(:category, name: "policy1") }
      let(:category2) { FactoryBot.create(:category, name: "policy2") }
      let(:building) { FactoryBot.create(:building) }

      before(:each) do
        building.categories << category1
        building.categories << category2
      end

      it "returns menu categories" do
        expect(helper.menu_category_list(building.categories)).to eql "policy1 and policy2"
      end
    end

    context "with just one category" do

      let(:category3) { FactoryBot.create(:category, name: "policy3") }
      let(:building) { FactoryBot.create(:building) }

      before(:each) do
        building.categories << category3
      end

      it "returns a menu category" do
        expect(helper.menu_category_list(building.categories)).to eql "policy3"
      end
    end
  end

  describe "librarysearch_url" do
    context "when envvar LIBRARYSEARCH_DOMAIN is not set" do
      it "returns the default production url" do
        expect(librarysearch_url).to eql "https://librarysearch.temple.edu"
      end
    end
    context "arguments are sent" do
      it "returns the search url with args appended" do
        expect(librarysearch_url("test")).to eql "https://librarysearch.temple.edu/test"
      end
    end
    context "arguments are not sent" do
      it "returns the search url with no args appended" do
        expect(librarysearch_url).to eql "https://librarysearch.temple.edu"
      end
    end
  end

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

end
