# frozen_string_literal: true

class Panopto::PastEventsComponent < ViewComponent::Base
  def initialize(videos:)
    @recent = videos.values_at(:recent)
    @featured_video = @recent.first[:videos].first
    @categories = videos
  end

end
