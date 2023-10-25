# frozen_string_literal: true

class Panopto::PastEventsVideoComponent < ViewComponent::Base
  def initialize(video:)
    @video_src = "https://temple.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=#{ video[:Id] }&autoplay=false&offerviewer=false&showtitle=false&showbrand=false&captions=false&interactivity=none"
    @video_name = video[:Name]
    @video_description = video[:Description]
  end
end
