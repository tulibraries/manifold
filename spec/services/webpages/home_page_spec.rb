# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpages::HomePage do
  describe ".call" do
    it "places the current highlighted exhibition before featured events" do
      exhibition = FactoryBot.create(
        :exhibition,
        title: "Highlighted Exhibition",
        start_date: Date.current,
        end_date: Date.current + 1,
        highlighted: true
      )

      later_event = FactoryBot.create(
        :event,
        title: "Later Featured Event",
        featured: true,
        start_time: Date.current + 3,
        end_time: Date.current + 4
      )

      sooner_event = FactoryBot.create(
        :event,
        title: "Sooner Featured Event",
        featured: true,
        start_time: Date.current + 1,
        end_time: Date.current + 2
      )

      result = described_class.call

      expect(result[:featured_events]).to eq(
        [exhibition, sooner_event, later_event]
      )
    end

    it "returns promoted highlights with images" do
      included = FactoryBot.create(:highlight, :with_image, promoted: true)
      FactoryBot.create(:highlight, promoted: true)
      FactoryBot.create(:highlight, :with_image, promoted: false)

      result = described_class.call

      expect(result[:highlights]).to contain_exactly(included)
    end

    it "returns digital collection highlights with images" do
      included = FactoryBot.create(
        :highlight,
        :with_image,
        promote_to_dig_col: true
      )

      FactoryBot.create(:highlight, promote_to_dig_col: true)

      result = described_class.call

      expect(result[:digcols]).to contain_exactly(included)
    end

    it "returns the homepage call-to-action categories" do
      cta3 = FactoryBot.create(
        :category,
        slug: "computers-printing-technology"
      )

      cta4 = FactoryBot.create(
        :category,
        slug: "explore-charles"
      )

      result = described_class.call

      expect(result[:cta3]).to eq(cta3)
      expect(result[:cta4]).to eq(cta4)
    end

    it "returns today's hours from the cache file" do
      file_path = Rails.root.join("public/cache/todays_hours")

      allow(File).to receive(:exist?).with(file_path).and_return(true)
      allow(File).to receive(:read).with(file_path).and_return("9:00 AM – 5:00 PM")

      result = described_class.call

      expect(result[:todays_hours]).to eq("9:00 AM – 5:00 PM")
    end

    it "returns nil when the today's hours cache file is missing" do
      file_path = Rails.root.join("public/cache/todays_hours")

      allow(File).to receive(:exist?).with(file_path).and_return(false)

      result = described_class.call

      expect(result[:todays_hours]).to be_nil
    end
  end
end
