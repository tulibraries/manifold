# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Panopto::VideoDistributor, type: :service do
  describe "#initialize" do
    it "does not authenticate when constructing the service" do
      expect(HTTParty).not_to receive(:post)

      described_class.new(
        type: "show",
        video_id: "video-123"
      )
    end
  end

  describe "#call" do
    it "authenticates when executing the service" do
      auth_response = double(
        body: '{"access_token":"test-token"}',
        code: 200
      )

      expect(HTTParty)
        .to receive(:post)
        .once
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(
          double(body: '{"Id":"video-123"}', code: 200)
        )

      service = described_class.new(
        type: "show",
        video_id: "video-123"
      )

      service.call
    end
  end

  context "Retrieves video data from API" do
    it "returns videos grouped by category" do
      auth_response = double(
        body: '{"access_token":"test-token"}',
        code: 200
      )

      videos_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
      )

      videos_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
      )

      video_response = double(
        body: '{"Id":"video-123","Name":"Example Video"}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
      )

      videos_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}',
        code: 200
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      allow(HTTParty)
        .to receive(:get)
        .and_return(videos_response)

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
        body: '{"access_token":"test-token"}',
        code: 200
      )

      search_response = double(
        body: '{"Results":[]}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
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
          double(body: first_page.to_json, code: 200)
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
        body: '{"access_token":"test-token"}',
        code: 200
      )

      collection_response = double(
        body: '{"Results":[{"Id":"video-123","Name":"Example Video"}]}',
        code: 200
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
        body: '{"access_token":"test-token"}',
        code: 200
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
          double(body: first_page.to_json, code: 200),
          double(body: second_page.to_json, code: 200)
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
        body: '{"access_token":"test-token"}',
        code: 200
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

    it "returns nil when authentication raises an error" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end

    it "returns nil when authentication does not return an access token" do
      auth_response = double(
        body: '{"error":"invalid_client"}',
        code: 200
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end

    it "rejects an unsuccessful authentication response containing an access token" do
      auth_response = double(
        body: '{"access_token":"test-token"}',
        code: 401
      )

      allow(HTTParty)
        .to receive(:post)
        .and_return(auth_response)

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end

    it "does not make an API request when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      expect(HTTParty)
        .not_to receive(:get)

      described_class.call(
        type: "show",
        video_id: "video-123"
      )
    end

    it "does not make an API request when authentication returns no access token" do
      allow(HTTParty)
        .to receive(:post)
        .and_return(
          double(
            body: '{"error":"invalid_client"}',
            code: 200
          )
        )

      expect(HTTParty)
        .not_to receive(:get)

      described_class.call(
        type: "show",
        video_id: "video-123"
      )
    end

    it "returns nil when an authenticated API request is unauthorized" do
      auth_response = double(
        body: '{"access_token":"test-token"}',
        code: 200
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

      expect(result).to be_nil
    end

    it "returns nil when the authentication response contains invalid JSON" do
      allow(HTTParty)
        .to receive(:post)
        .and_return(
          double(body: "not-json", code: 200)
        )

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end

    it "returns nil when the authentication response body is empty" do
      allow(HTTParty)
        .to receive(:post)
        .and_return(
          double(body: "", code: 200)
        )

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(
        type: "show",
        video_id: "video-123"
      )

      expect(result).to be_nil
    end

    it "returns an empty search result when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(
        type: "search",
        query: "livingstone"
      )

      expect(result).to eq(
        ["livingstone", 0, []]
      )
    end

    it "returns a retrieval failure for a collection when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(
        type: "collection",
        collection: "recent"
      )

      expect(result).to eq(
        ["Recent Videos", [], :retrieval_failed]
      )
    end

    it "does not make API requests for all videos when authentication fails" do
      allow(HTTParty)
        .to receive(:post)
        .and_raise(StandardError, "authentication failed")

      expect(HTTParty)
        .not_to receive(:get)

      result = described_class.call(type: "all")

      expect(result).to be_nil
    end

    it "returns nil when the API response contains invalid JSON" do
      auth_response = double(
        body: '{"access_token":"test-token"}',
        code: 200
      )

      invalid_response = double(
        body: "not-json",
        code: 200
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
