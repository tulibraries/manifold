# frozen_string_literal: true

require "rails_helper"

RSpec.describe Highlight, type: :model do
  it_behaves_like "imageable"

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

  describe "#featured_image" do
    let(:highlight) { FactoryBot.create(:highlight) }

    before do
      highlight.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/dream.jpg")),
        filename: "dream.jpg",
        content_type: "image/jpeg"
      )
    end

    it "pads the processed image to the homepage highlight frame" do
      featured_image = highlight.featured_image
      processed_image = MiniMagick::Image.read(featured_image.processed.download)
      top_left_pixel = processed_image.get_pixels.first.first.first(3)

      expect(featured_image.variation.transformations).to include(
        format: :png,
        background: "#F7F7F7",
        gravity: "Center",
        resize_to_fit: [420, 270],
        extent: "420x270"
      )
      expect(processed_image.dimensions).to eq([420, 270])
      expect(top_left_pixel).to eq([247, 247, 247])
    end
  end

end
