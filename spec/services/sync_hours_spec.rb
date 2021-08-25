# frozen_string_literal: true

require "rails_helper"
require "net/http"
require "webmock/rspec"
require "vcr"

RSpec.describe SyncService::LibraryHours, type: :service do

  context "GOOGLE API" do
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

  context "JSON Parsing" do
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

  context "Syncs data from Google Spreadsheet" do
    before(:all) do
      VCR.configure do |config|
        config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
        config.hook_into :webmock
        config.default_cassette_options = {
          match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key)]
        }
      end
    end

    let(:the_date) { DateTime.parse("June 10, 2019 00:00 EDT") }
    let(:the_location) { "charles" }

    it "uploads the data" do
      library_hours = LibraryHour.where(date: the_date, location_id: the_location)
      VCR.use_cassette("syncServiceLibraryHours") do
        SyncService::LibraryHours.call
      end
      library_hours = LibraryHour.where(date: the_date, location_id: the_location).first
      expect(library_hours.hours).to eq("8:00 am - 10:00 pm")
    end
  end
end
