# frozen_string_literal: true

class Panopto::PastEventsComponent < ViewComponent::Base
  def initialize(videos:)
    # binding.pry
    @recent = videos.values_at(:recent)
    @featured_video = @recent.first[:videos].first
    @featured_src = "https://temple.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=#{ @featured_video[:Id] }&autoplay=false&offerviewer=false&showtitle=false&showbrand=false&captions=false&interactivity=none"
    @categories = videos
  end

end
