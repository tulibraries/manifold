# frozen_string_literal: true

module Panopto
  class VideoLookup < ApplicationService
    def initialize(video_id)
      @video_id = video_id
    end

    def call
      return if @video_id.blank?

      video = VideoDistributor.call(type: "show", video_id: @video_id)

      return if video == true
      return if video.blank?
      return if video[:Message] == "The request is invalid."

      video
    end
  end
end
