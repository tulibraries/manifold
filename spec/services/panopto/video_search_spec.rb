# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::VideoSearch do
  describe ".call" do
    it "returns search results" do
      videos = [
        "livingstone",
        1,
        [{ Id: "video-123", Name: "Example Video" }]
      ]

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "search", query: "livingstone")
        .and_return(videos)

      result = described_class.call("livingstone")

      expect(result).to eq(videos)
    end

    it "returns nil when the query is blank" do
      result = described_class.call(nil)

      expect(result).to be_nil
    end
  end
end
