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

  describe "json response" do
    context "json_ld" do
      let(:entity) { OpenStruct.new(map_to_schema_dot_org: { one: 2 }) }
      let(:ld) { json_ld(entity) }

      it "returns parseable json" do
        expect(JSON.parse(ld)).to eql("one" => 2)
      end
    end
  end

  describe "menu navigation" do
    context "parses out non-category menu groups" do
      let(:category) { FactoryBot.create(:category, name: "Menu Group") }
      let(:menu_item_1) { FactoryBot.create(:webpage, title: "Menu Item 1", categories: [category]) }
      let(:menu_item_2) { FactoryBot.create(:webpage, title: "Menu Item 2") }

      it "returns list of links within child category group" do
        expect(menu_item_1).to be
        expect(helper.get_item_list(category)).to include(menu_item_1.label)
      end
      it "does not allow non-categories" do
        expect(menu_item_2).to be
        expect(helper.get_item_list(menu_item_2)).to_not be
      end
    end
  end

end
