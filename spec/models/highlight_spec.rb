# frozen_string_literal: true

require "rails_helper"

RSpec.describe Highlight, type: :model do

  describe "validations" do
    it { should validate_presence_of(:title) }
  end

  describe "with_image scope" do
    before do
      @h1 = FactoryBot.create(:highlight, :with_image)
      @h2 = FactoryBot.create(:highlight)
    end

    it "only returns highlights with images attached" do
      expect(Highlight.with_image).to include(@h1)
      expect(Highlight.with_image).to_not include(@h2)
    end
  end

  describe "digcol promoted scope" do
    before do
      @h1 = FactoryBot.create(:highlight, :with_image, promote_to_dig_col: true)
      @h2 = FactoryBot.create(:highlight, promote_to_dig_col: true)
      @h3 = FactoryBot.create(:highlight, :with_image)
    end

    it "only returns promoted highlights with images attached" do
      expect(Highlight.with_image.for_digital_collections).to include(@h1)
      expect(Highlight.with_image.for_digital_collections).to_not include(@h2)
      expect(Highlight.with_image.for_digital_collections).to_not include(@h3)
    end
  end

end
