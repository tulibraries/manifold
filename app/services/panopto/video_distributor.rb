# frozen_string_literal: true

require 'net/https'
require 'open-uri'
require 'json'

module Panopto

  class VideoDistributor < ApplicationService

    def initialize(*args)
      begin
        @type = args.first[:type]
        @collection = args.first[:collection]
        @video_id = args.first[:video_id]
        @query = args.first[:query]
        key = ENV["PANOPTO_API_USER"]
        code = ENV["PANOPTO_API_KEY"]
        auth = { username: key, password: code }
        params = { "scope" => "api", "grant_type" => "client_credentials" }
        response = HTTParty.post("https://temple.hosted.panopto.com/Panopto/oauth2/connect/token", body: params, basic_auth: auth)
        @access_token = JSON.parse(response.body, symbolize_names: true)[:access_token] if response.body.present?
      rescue => e
        e.message
      end
    end
  
    def call
      @categories = {"recent" => ["recent", "Recent Videos", "98a7258a-f81f-48c1-8541-af1900e5a7af"],
        "beyond-the-page" => ["beyond-the-page", "Beyond the Page", "eba32425-d6bf-4e9c-983f-af1f0128b62b"],
        "beyond-the-notes" => ["beyond-the-notes", "Beyond the Notes", "e01cdfba-bc19-4f27-bdc6-af1c00f52773"],
        "blockson" => ["blockson", "Charles L. Blockson Afro-American Collection", "1aab1d3f-4626-43fd-924d-af1c00f290d5"],
        "research-awards" => ["research-awards", "Livingstone Undergraduate Research Awards", "ad6a8ada-242e-4ddd-8115-af1c00fc3621"],
        "lcdss" => ["lcdss", "Loretta C. Duckworth Scholars Studio", "d320fce9-a51c-4e6f-b85a-af1901046d79"],
        "scrc" => ["scrc", "Special Collections Research Center", "980a89be-5d85-43e2-b171-af1c00fdd352"]}

      case @type
      when "all"
        video_call = panopto_api_call(["playlists", "sessions"], "98a7258a-f81f-48c1-8541-af1900e5a7af")
        videos = get_video_categories(video_call)
      when "collection"
        if @categories.keys.include?(@collection)
          category = @categories.fetch(@collection)
          videos = videos_list(category) if category.present?
        end
      when "show"
        video = video_show(@video_id)
      when "search"
        videos = videos_search(@query)
      end
    end

    private

      def panopto_api_call(type, panopto_id)
        begin
          api_query = "https://temple.hosted.panopto.com/Panopto/api/v1/#{ type[0] }/#{ panopto_id }/"
          api_query += "#{ type[1] }/" if type[1].present?
          api_query += "#{ type[2] }" if type[2].present?
          api_query += "?id=#{ panopto_id }&searchQuery=#{ type[3] }" if type[3].present?
          api_query += "&pageNumber=#{ type[4] }" if type[3].present? && type[4].present?
          api_query += "?pageNumber=#{ type[4] }" if type[3].nil? && type[4].present?
          request = HTTParty.get(api_query, headers: { "Authorization" => "Bearer #{ @access_token }" })
          JSON.parse(request.body, symbolize_names: true) if request.body.size > 0
        rescue => e
          Rails.logger.debug e
        end
      end

      def get_video_categories(videos)

        recent = [] 
        beyond_page = [] 
        beyond_notes = [] 
        blockson = [] 
        awards = [] 
        lcdss = [] 
        scrc = []

        @categories.each do |category|
          get_videos = panopto_api_call(["playlists", "sessions"], category[1][2])
          get_videos[:Results].each do |video|
            case category[0]
            when "recent"
              recent << video
            when "beyond-the-page"
              beyond_page << video
            when "beyond-the-notes"
              beyond_notes << video
            when "blockson"
              blockson << video
            when "research-awards"
              awards << video
            when "lcdss"
              lcdss << video
            when "scrc"
              scrc << video
            end
          end       
        end 
        
        videos_by_category = { 
                              :recent => {:slug => "recent", :label => "Recent Videos", :videos => recent.take(10)}, 
                              :beyond_page => {:slug => "beyond-the-page", :label => "Beyond the Page", :videos => beyond_page.take(5)}, 
                              :beyond_notes => {:slug => "beyond-the-notes", :label => "Beyond the Notes", :videos => beyond_notes.take(5)}, 
                              :blockson => {:slug => "blockson", :label => "Charles L. Blockson Afro-American Collection", :videos => blockson.take(5)}, 
                              :awards => {:slug => "awards", :label => "Livingstone Undergraduate Research Awards", :videos => awards.take(5)}, 
                              :lcdss => {:slug => "lcdss", :label => "Loretta C. Duckworth Scholars Studio", :videos => lcdss.take(5)}, 
                              :scrc => {:slug => "scrc", :label => "Special Collections Research Center", :videos => scrc.take(5)}
                            }
      end

      def videos_list(collection)
        page_results = []
        more = false
        i = 0

        if collection.present?
          page_results = panopto_api_call(["playlists", "sessions", nil, nil, i], collection[2])
          @videos = page_results[:Results]

          more = true if @videos.size == 50
          while more
            page_results = nil
            i += 1
            results = panopto_api_call(["playlists", "sessions", nil, nil, i], collection[2])
            page_results = results[:Results] if results.present? && results[:Results].size > 0 && results[:Results].size <= 50

            if page_results.present?
              more = (page_results.size == 50) ? true : false
              @videos += page_results
            end
          end
          [collection[1], @videos]
        end
      end

      def video_show(video)
        @video = panopto_api_call(["sessions", nil], video)
      end

      def videos_search(query)
        page_results = panopto_api_call(["folders", "sessions", "search", query, nil], "e2753a7a-85c2-4d00-a241-aecf00393c25")
        if page_results.present?
          videos = page_results[:Results]
          @videos = [query, videos.size, videos]
        end
      end
  
  end     
end
