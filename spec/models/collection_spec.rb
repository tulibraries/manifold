# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection, type: :model do
  after(:each) do
    DatabaseCleaner.clean
  end

  describe "Required attributes" do
    let(:collection) { FactoryBot.create(:collection) }

    example "Missing name" do
      collection = FactoryBot.build(:collection, name: "")
      expect { collection.save! }.to raise_error(/Name can't be blank/)
    end

    example "Missing description" do
      collection = FactoryBot.build(:collection, description: "")
      expect { collection.save! }.to raise_error(/Description can't be blank/)
    end
  end

  describe "Building association" do
    example "Specify building in a collection" do
      building = FactoryBot.build(:building)
      collection = FactoryBot.create(:collection, building: building)
      expect(collection.building).to be(building)
    end
  end
end
