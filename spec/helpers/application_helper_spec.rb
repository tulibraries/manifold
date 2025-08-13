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
        result = helper.menu_category_list(building.categories)
        expect(result).to match(/^(policy1 and policy2|policy2 and policy1)$/)
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
    end
  end

  describe "get_season" do
    context " -- returns season --" do
      it "winter" do
        Timecop.freeze(Time.zone.local(2022, 12, 21)) do
          expect(helper.get_season).to eql "winter"
        end
        Timecop.freeze(Time.zone.local(2023, 1, 1)) do
          expect(helper.get_season).to eql "winter"
        end
        Timecop.freeze(Time.zone.local(2023, 2, 1)) do
          expect(helper.get_season).to eql "winter"
        end
        Timecop.freeze(Time.zone.local(2023, 3, 20)) do
          expect(helper.get_season).to eql "winter"
        end
      end
      it "spring" do
        Timecop.freeze(Time.zone.local(2023, 3, 21)) do
          expect(helper.get_season).to eql "spring"
        end
        Timecop.freeze(Time.zone.local(2023, 4, 1)) do
          expect(helper.get_season).to eql "spring"
        end
        Timecop.freeze(Time.zone.local(2023, 5, 1)) do
          expect(helper.get_season).to eql "spring"
        end
        Timecop.freeze(Time.zone.local(2023, 6, 20)) do
          expect(helper.get_season).to eql "spring"
        end
      end
      it "sumer" do
        Timecop.freeze(Time.zone.local(2023, 6, 21)) do
          expect(helper.get_season).to eql "summer"
        end
        Timecop.freeze(Time.zone.local(2023, 7, 1)) do
          expect(helper.get_season).to eql "summer"
        end
        Timecop.freeze(Time.zone.local(2023, 8, 1)) do
          expect(helper.get_season).to eql "summer"
        end
        Timecop.freeze(Time.zone.local(2023, 9, 20)) do
          expect(helper.get_season).to eql "summer"
        end
      end
      it "fall" do
        Timecop.freeze(Time.zone.local(2023, 9, 21)) do
          expect(helper.get_season).to eql "fall"
        end
        Timecop.freeze(Time.zone.local(2023, 10, 1)) do
          expect(helper.get_season).to eql "fall"
        end
        Timecop.freeze(Time.zone.local(2023, 11, 1)) do
          expect(helper.get_season).to eql "fall"
        end
        Timecop.freeze(Time.zone.local(2023, 12, 20)) do
          expect(helper.get_season).to eql "fall"
        end
      end
    end
  end

  describe "#get_items" do
    context "category is nil" do
      let(:category) { nil }

      it "handles nil values gracefully" do
        expect(helper.get_items(category)).to be("")
      end
    end

    context "category has no items" do
      let(:category) { FactoryBot.create(:category) }
      let(:items) { nil }

      it "handles no items gracefully" do
        expect(helper.get_items(category)).to be("")
      end
    end

    context "category.items is greater than 0" do
      let(:category) { FactoryBot.create(:category, :only_name) }
      let(:items) { FactoryBot.create(:building) }

      it "adds a list item" do
        allow(category).to receive(:items).and_return([items])
        expect(helper.get_items(category)).to include(items.label)
      end
    end
  end
end
