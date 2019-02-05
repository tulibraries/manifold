# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection, type: :model do
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

  describe "Space association" do
    example "Specify space in a collection" do
      space = FactoryBot.build(:space)
      collection = FactoryBot.create(:collection, space: space)
      expect(collection.space).to be(space)
    end
  end
end
