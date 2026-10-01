# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Panopto::VideoDistributor, type: :service do
  context "Retrieves video data from API" do
    it "returns videos grouped by category" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      videos_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(videos_response)

      result = described_class.call(type: "all")

      expect(result.keys).to eq(
        %i[
          recent
          beyond_page
          beyond_notes
          blockson
          awards
          lcdss
          scrc
        ]
      )

      expect(result[:recent]).to eq(
        slug: "recent",
        label: "Recent Videos",
        videos: [
          { Id: "video-123", Name: "Example Video" }
        ]
      )

      expect(result[:scrc]).to eq(
        slug: "scrc",
        label: "Special Collections Research Center",
        videos: [
          { Id: "video-123", Name: "Example Video" }
        ]
      )
    end

    it "returns an empty category when one category API request fails" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      videos_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty).to receive(:get) do |url, **_options|
        if url.include?("eba32425-d6bf-4e9c-983f-af1f0128b62b")
          raise StandardError, "connection failed"
        end

        videos_response
      end

      result = described_class.call(type: "all")

      expect(result[:recent][:videos]).to eq(
        [{ Id: "video-123", Name: "Example Video" }]
      )

      expect(result[:beyond_page][:videos]).to eq([])

      expect(result[:scrc][:videos]).to eq(
        [{ Id: "video-123", Name: "Example Video" }]
      )
    end

    it "returns video data for a successful show request" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      video_response = double(
        body: '{"Id":"video-123","Name":"Example Video"}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(video_response)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to eq(
        Id: "video-123",
        Name: "Example Video"
      )
    end

    # it "redirect on missing video" do
    #   video = Panopto::VideoDistributor.new(type: "show", video_id: "7")
    #   request.to redirect_to "/watchpastprogram"
    # end

    it "returns search results" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      search_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(search_response)

      result = described_class.call(
        type: "search",
        query: "concert"
      )

      expect(result).to eq(
        [
          "concert",
          1,
          [{ Id: "video-123", Name: "Example Video" }]
        ]
      )
    end

    it "returns an empty search result when Panopto returns no matches" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      search_response = double(
        body: '{"Results":[]}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(search_response)

      result = described_class.call(
        type: "search",
        query: "no matches"
      )

      expect(result).to eq(
        ["no matches", 0, []]
      )
    end

    it "returns an empty search result when the API request fails" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_raise(StandardError, "connection failed")

      result = described_class.call(
        type: "search",
        query: "concert"
      )

      expect(result).to eq(
        ["concert", 0, []]
      )
    end

    it "returns an empty collection when a later page request fails" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      first_page = {
        Results: 50.times.map do |i|
          { Id: "video-#{i}", Name: "Video #{i}" }
        end
      }

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      call_count = 0

      allow(HTTParty).to receive(:get) do
        call_count += 1

        if call_count == 1
          double(body: first_page.to_json)
        else
          raise StandardError, "connection failed"
        end
      end

      result = described_class.call(
        type: "collection",
        collection: "recent"
      )

      expect(result).to eq(
        ["Recent Videos", [], :retrieval_failed]
      )
    end

    it "returns videos for a collection" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      collection_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(collection_response)

      result = described_class.call(
        type: "collection",
        collection: "recent"
      )

      expect(result).to eq(
        [
          "Recent Videos",
          [{ Id: "video-123", Name: "Example Video" }]
        ]
      )
    end

    it "requests a second page when the first collection page has 50 videos" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      first_page = {
        Results: 50.times.map do |i|
          { Id: "video-#{i}", Name: "Video #{i}" }
        end
      }

      second_page = {
        Results: [
          { Id: "video-50", Name: "Video 50" }
        ]
      }

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(
          double(body: first_page.to_json),
          double(body: second_page.to_json)
        )

      result = described_class.call(
        type: "collection",
        collection: "recent"
      )

      expect(result.first).to eq("Recent Videos")
      expect(result.last.size).to eq(51)
      expect(result.last.last).to eq(
        Id: "video-50",
        Name: "Video 50"
      )
    end

    it "returns an empty collection when the initial page request fails" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_raise(StandardError, "connection failed")

      result = described_class.call(
        type: "collection",
        collection: "recent"
      )

      expect(result).to eq(
        ["Recent Videos", [], :retrieval_failed]
      )
    end

    it "continues initialization when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      allow(HTTParty)
        .to receive(:get)
        .and_return(
          double(
            body: '{"Id":"video-123","Name":"Example Video"}'
          )
        )

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to eq(
        Id: "video-123",
        Name: "Example Video"
      )
    end

    it "continues when the authentication response does not contain an access token" do
      auth_response = double(
        body: '{"error":"invalid_client"}'
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(
          double(
            body: '{"Id":"video-123","Name":"Example Video"}'
          )
        )

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to eq(
        Id: "video-123",
        Name: "Example Video"
      )
    end

    it "sends a bearer request without a token when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      allow(HTTParty)
        .to receive(:get)
        .with(
          "https://temple.hosted.panopto.com/Panopto/api/v1/sessions/video-123/",
          headers: { "Authorization" => "Bearer " }
        )
        .and_return(
          double(
            body: '{"Id":"video-123","Name":"Example Video"}'
          )
        )

      described_class.call(
        type: "show",
        video_id: "video-123"
      )
    end

    it "returns the API error response when an authenticated request is unauthorized" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      unauthorized_response = double(
        body: '{"Message":"Unauthorized"}',
        code: 403
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(unauthorized_response)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to eq(
        Message: "Unauthorized"
      )
    end

    it "returns nil when the API response contains invalid JSON" do
      auth_response = double(
        body: '{"access_token":"test-token"}'
      )

      invalid_response = double(
        body: "not-json"
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(invalid_response)

      allow(Rails.logger)
        .to receive(:debug)
        .and_return(true)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end
  end
end
