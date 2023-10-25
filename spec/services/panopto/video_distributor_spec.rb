# frozen_string_literal: true

require "rails_helper"
require "ostruct"

RSpec.describe Panopto::VideoDistributor, type: :service do
  context "Retrieves video data from API" do
    it "gets videos_all" do
      videos = Panopto::VideoDistributor.new(type: "all")
      expect(videos).to be
    end

    it "gets videos_list" do
      videos = Panopto::VideoDistributor.new(type: "collection", collection: "recent")
      expect(videos).to be
    end

    it "gets video_show" do
      video = Panopto::VideoDistributor.new(type: "show", video_id: "87710ba5-25eb-4f3e-ae83-b06c013e2687")
      expect(video).to be
    end

    # it "redirect on missing video" do
    #   video = Panopto::VideoDistributor.new(type: "show", video_id: "7")
    #   request.to redirect_to "/watchpastprogram"
    # end

    it "gets videos_search" do
      videos = Panopto::VideoDistributor.new(type: "search", query: "concert")
      expect(videos).to be
    end
  end

end
