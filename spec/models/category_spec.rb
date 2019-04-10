# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do

  let(:category) { FactoryBot.create(:category) }

  describe "A basic category" do
    context "has a name" do
      it "doesn't error when built" do
        expect { category }.not_to raise_error
      end

      it "has a name attribute" do
        expect(category).to respond_to(:name)
      end

      it "returns the expectd value for name" do
        expect(category.name).to eql("Dreaming")
      end
    end

    context "when it doesn't have a name" do
      let(:category) { FactoryBot.build(:category) }
      it "should raise a validation error" do
        category.name = nil
        expect { category.save! }.to raise_error(/Name can't be blank/)
      end
    end
  end

  describe "A category with an icon" do
    let(:category) { FactoryBot.create(:category, :with_icon) }

    it "responds to icon" do
      expect(category).to respond_to(:icon)
    end

    it "responds with blob" do
      expect(category.icon).to be_a_kind_of(ActiveStorage::Attached::One)
    end
  end

  describe "#url" do

    let(:category) { FactoryBot.create(:category) }

    it "responds to .url" do
      expect(category).to respond_to(:url)
    end

    context "no custom_url defined" do
      it "returns the expected path" do
        pending("category routes not yet implemented")
        expect(category.url).to contain("/category")
      end
    end

    context "with custom_url defined" do
      let(:category) { FactoryBot.create(:category, :custom_url) }

      it "returns the expected path" do
        expect(category.url).to eq "http://sand.man"
      end
    end
  end
  describe "#items" do
    let(:building) { FactoryBot.create(:building) }
    let(:building2) { FactoryBot.create(:building) }
    let(:event) { FactoryBot.create(:event) }

    context "no items categorized" do
      it "should return an array" do
        expect(category.items).to be_a_kind_of(Array)
      end

      it "should be an empty array" do
        expect(category.items).to eql []
      end
    end

    context "items of one type in this category" do
      before do
        building.categories << category
        building2.categories << category
      end
      it "should return an array" do
        expect(category.items).to be_a_kind_of(Array)
      end

      it "should include expected items" do
        expect(category.items).to include(building, building2)
      end
    end

    context "items of one type in this category" do
      before do
        building.categories << category
        event.categories << category
      end

      it "should include expected items" do
        expect(category.items).to include(building, event)
      end
    end

  end
end
