class StreamingVideosController < ApplicationController
  before_action :set_streaming_video, only: %i[ show ]
  include SetInstance

  def index
    @streaming_videos = StreamingVideo.all
  end

  def show
  end

  def videos_all
    @all = []
    @lists = [
              @recent = [],
              @beyond_page = [],
              @beyond_notes = [],
              @blockson = [],
              @awards = [],
              @lcdss = [],
              @scrc = []
             ]

    get_video_categories.each do |category|
      get_videos = panopto_api_call(["playlists", "sessions"], category[2])
      get_videos[:Results].each do |video|
        @all << video
        case category[1]
        when "Documentaries"
          @documentaries << video
        when "Philadelphia Stories"
          @phila_stories << video
        when "Beyond the Notes"
          @beyond_notes << video
        end
      end
    end

    unless @recent.nil?
      @featured_video_id = @recent.first[:Id]
      @featured_video_title = @recent.first[:Name]
    else
      return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video information.")
    end
  end

  def get_video_categories
    @lists = [
              @documentaries = [],
              @feature_films = [],
              @philadelphia_stories = []
             ]
    
    @panopto_collection = params[:panopto_collection]

    @categories = ["documentaries", "Documentaries", "72465e2b-7d68-45b7-bdb3-af63013c5d6b"],
                  ["feature-films", "Feature Films", "06cb9155-c6f3-42e3-96a0-af630141492b"],
                  ["philadelphia-stories", "Philadelphia Stories", "1c89e3ca-a0dc-45de-9f7f-af630135c58d"]

    @categories.each do |category|
      get_videos = panopto_api_call(["playlists", "sessions"], category[2])
      get_videos[:Results].each do |video|
        @all << video
        case category[1]
        when "Documentaries"
          @documentaries << video
        when "Feature Films"
          @feature_films << video
        when "Philadelphia Stories"
          @philadelphia_stories << video
        end
      end
    end
  end

  private
    def set_streaming_video
      @streaming_video = find_instance
    end
end
