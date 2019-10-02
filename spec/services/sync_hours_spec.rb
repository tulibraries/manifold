# frozen_string_literal: true

require "rails_helper"
require "net/http"
require "webmock/rspec"

RSpec.describe SyncService::LibraryHours, type: :service do

  before(:all) do
    @body = file_fixture("library_hours.json").read
    @body_size = file_fixture("library_hours.json").size

    WebMock.stub_request(:get, "www.example.com").
      to_return(body: @body, status: "200",
               headers: { "Content-Length" => @body_size })

    uri = URI("http://www.example.com/")
    req = Net::HTTP::Get.new(uri)
    @resp = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }

    @json = JSON.parse(@resp.body)
  end

  context "Google API responds" do
    it "response has Google data" do
      expect(@resp.body).to match(@body)
    end

    it "Response has expected column headings" do
      @json["values"].first.each do |heading|
        expect(heading).not_to be nil
      end
    end

    it "Response has fields with data" do
      @json["values"].second.each do |hours|
        expect(hours).not_to be nil
      end
      @json["values"].third.each do |hours|
        expect(hours).not_to be nil
      end
    end
  end

end

RSpec.describe SyncService::LibraryHours, type: :service do

  before(:all) do
    @body = file_fixture("library_hours.json").read
    @body_size = file_fixture("library_hours.json").size

    WebMock.stub_request(:get, "www.example.com")

    uri = URI("http://www.example.com/")
    req = Net::HTTP::Get.new(uri)
    @resp = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
  end

  context "Google API fails to respond or times out" do
    it "response does not have google data" do
      expect(@resp.body).not_to match(@body)
    end

    it "Response has expected column headings" do
      expect(@resp.body).to eq("")
    end

    it "Response has fields with data" do
      expect(@resp.body).to eq("")
    end
  end
end
