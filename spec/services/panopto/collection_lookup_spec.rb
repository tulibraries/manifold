# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::CollectionLookup do
  describe ".call" do
    it "returns videos for a valid collection" do
      videos = [
        "Beyond the Page",
        [{ Id: "video-123", Name: "Example Video" }]
      ]

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "collection", collection: "beyond-the-page")
        .and_return(videos)

      result = described_class.call("beyond-the-page")

      expect(result).to eq(videos)
    end

    it "returns nil when no videos are returned" do
      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "collection", collection: "missing")
        .and_return(nil)

      result = described_class.call("missing")

      expect(result).to be_nil
    end

    it "returns nil when the collection is blank" do
      result = described_class.call(nil)

      expect(result).to be_nil
    end
  end
end
