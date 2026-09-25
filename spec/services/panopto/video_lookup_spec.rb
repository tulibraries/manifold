# frozen_string_literal: true

require "rails_helper"

RSpec.describe Panopto::VideoLookup do
  describe ".call" do
    it "returns a valid video" do
      video = {
        Id: "video-123",
        Name: "Example Video",
        Description: "Example description"
      }

      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "show", video_id: "video-123")
        .and_return(video)

      result = described_class.call("video-123")

      expect(result).to eq(video)
    end

    it "returns nil for an invalid request response" do
      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "show", video_id: "invalid")
        .and_return(Message: "The request is invalid.")

      result = described_class.call("invalid")

      expect(result).to be_nil
    end

    it "returns nil when Panopto returns true" do
      allow(Panopto::VideoDistributor)
        .to receive(:call)
        .with(type: "show", video_id: "video-123")
        .and_return(true)

      result = described_class.call("video-123")

      expect(result).to be_nil
    end

    it "returns nil when the video id is blank" do
      result = described_class.call(nil)

      expect(result).to be_nil
    end
  end
end
