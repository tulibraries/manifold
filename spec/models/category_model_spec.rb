# frozen_string_literal: true

require "rails_helper"

RSpec.describe Category, type: :model do

  describe "A basic category" do
    let(:category) { FactoryBot.create(:category)}

    it "doesn't error whe built" do
      expect { category }.not_to raise_error
    end

    it "has a name attribute" do
      expect(category).to respond_to(:name)
    end

    it "returns the expectd value for name" do
      expect(category.name).to eql("Dreaming")
    end
  end
end
