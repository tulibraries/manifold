 
require 'net/https'
require 'open-uri'
require 'json'

class Tokenizer < ApplicationService

  def initialize(*args)
    begin
      key = ENV["PANOPTO_API_USER"]
      code = ENV["PANOPTO_API_KEY"]

      auth = { username: key, password: code }
      params = { "scope" => "api", "grant_type" => "client_credentials" }
      response = HTTParty.post("https://temple.hosted.panopto.com/Panopto/oauth2/connect/token", body: params, basic_auth: auth)
      stdout_and_log("response: #{response}")
      @access_token = JSON.parse(response.body, symbolize_names: true)[:access_token] if response.body.present?

    rescue => e
      e.message
    end
  end

  # def call
  #   videos_all
  # end

  private

    # def panopto_api_call(type, panopto_id)
    #   begin
    #     api_query = "https://temple.hosted.panopto.com/Panopto/api/v1/#{ type[0] }/#{ panopto_id }/"
    #     api_query += "#{ type[1] }/" if type[1].present?
    #     api_query += "#{ type[2] }" if type[2].present?
    #     api_query += "?id=#{ panopto_id }&searchQuery=#{ type[3] }" if type[3].present?
    #     api_query += "&pageNumber=#{ type[4] }" if type[3].present? && type[4].present?
    #     api_query += "?pageNumber=#{ type[4] }" if type[3].nil? && type[4].present?
    #     request = HTTParty.get(api_query, headers: { "Authorization" => "Bearer #{ @access_token }" })
    #     JSON.parse(request.body, symbolize_names: true) if request.body.size > 0
    #   rescue => e
    #     Rails.logger.debug e
    #   end
    # end

    # def get_video_categories
    #   @categories = ["recent", "Recent Videos", "98a7258a-f81f-48c1-8541-af1900e5a7af"],
    #                 ["beyond-the-page", "Beyond the Page", "eba32425-d6bf-4e9c-983f-af1f0128b62b"],
    #                 ["beyond-the-notes", "Beyond the Notes", "e01cdfba-bc19-4f27-bdc6-af1c00f52773"],
    #                 ["blockson", "Charles L. Blockson Afro-American Collection", "1aab1d3f-4626-43fd-924d-af1c00f290d5"],
    #                 ["research-awards", "Livingstone Undergraduate Research Awards", "ad6a8ada-242e-4ddd-8115-af1c00fc3621"],
    #                 ["lcdss", "Loretta C. Duckworth Scholars Studio", "d320fce9-a51c-4e6f-b85a-af1901046d79"],
    #                 ["scrc", "Special Collections Research Center", "980a89be-5d85-43e2-b171-af1c00fdd352"]
    # end

    # def videos_all
    #   @all = []
    #   @lists = [
    #             @recent = [],
    #             @beyond_page = [],
    #             @beyond_notes = [],
    #             @blockson = [],
    #             @awards = [],
    #             @lcdss = [],
    #             @scrc = []
    #           ]

    #   get_video_categories.each do |category|
    #     get_videos = panopto_api_call(["playlists", "sessions"], category[2])
    #     get_videos[:Results].each do |video|
    #       @all << video
    #       case category[1]
    #       when "Recent Videos"
    #         @recent << video
    #       when "Beyond the Page"
    #         @beyond_page << video
    #       when "Beyond the Notes"
    #         @beyond_notes << video
    #       when "Charles L. Blockson Afro-American Collection"
    #         @blockson << video
    #       when "Livingstone Undergraduate Research Awards"
    #         @awards << video
    #       when "Loretta C. Duckworth Scholars Studio"
    #         @lcdss << video
    #       when "Special Collections Research Center"
    #         @scrc << video
    #       end
    #     end
    #   end
    # end

    # def videos_list
    #   page_results = []
    #   more = false
    #   i = 0
    #   @category = get_video_categories.select { |c| c[0] == params[:collection] }.first

    #   if @category.present?
    #     page_results = panopto_api_call(["playlists", "sessions", nil, nil, i], @category[2])
    #     @videos = page_results[:Results]
    #     more = true if @videos.size == 50
    #     while more
    #       page_results = nil
    #       i += 1
    #       results = panopto_api_call(["playlists", "sessions", nil, nil, i], @category[2])
    #       page_results = results[:Results] if results.present? && results[:Results].size > 0 && results[:Results].size <= 50

    #       if page_results.present?
    #         @videos += page_results
    #       end

    #       more = (page_results.present? && page_results.size == 50) ? true : false
    #     end
    #   else
    #     return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video list.")
    #   end
    # end

    # def videos_show
    #   @displayMode = "show"
    #   if params[:id].present?
    #     @video = panopto_api_call(["sessions", nil], params[:id])
    #     if @video.blank?
    #       return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video. #{ @video[:Id] }")
    #     end
    #     if @video[:Id].nil?
    #       return redirect_to(webpages_videos_all_path, alert: "Unable to retrieve video.")
    #     end
    #   else
    #     return redirect_to(webpages_videos_all_path, alert: "You must choose a video to stream.")
    #   end
    # end

    # def videos_search
    #   page_results = []
    #   more = false
    #   i = 0
    #   if params[:q].blank?
    #     return redirect_to(webpages_videos_all_path)
    #   else
    #     page_results = panopto_api_call(["folders", "sessions", "search", params[:q], i], "e2753a7a-85c2-4d00-a241-aecf00393c25")
    #     if page_results.present?
    #       @videos = page_results[:Results]
    #       more = true if @videos.size == 50
    #       while more
    #         page_results = nil
    #         i += 1
    #         results = panopto_api_call(["folders", "sessions", "search", params[:q], i], "e2753a7a-85c2-4d00-a241-aecf00393c25")
    #         page_results = results[:Results] if results.present? && results[:Results].size > 0 && results[:Results].size <= 50

    #         if page_results.present?
    #           @videos += page_results
    #         end

    #         more = (page_results.present? && page_results.size == 50) ? true : false
    #       end
    #       @categoryTitle = "your search for: <span style=\"color:#A41E35;\">\"#{params[:q]}\"</span> returned #{@videos.count} results"
    #     else
    #       @categoryTitle = "your search for: <span style=\"color:#A41E35;\">\"#{params[:q]}\"</span> returned 0 results"
    #     end
    #   end
    # end

    # def stdout_and_log(message, level: :info)
    #   @log = Logger.new("log/video-api.log")
    #   @stdout = Logger.new(STDOUT)
    #   @log.send(level, message)
    #   @stdout.send(level, message)
    # end
end