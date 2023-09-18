# frozen_string_literal: true

class Panopto::PastEventsSearchComponent < ViewComponent::Base
  def initialize(videos:)
    query = videos[0]
    count = videos[1]
    @videos = videos[2]
    @categoryTitle = "your search for: <span style=\"color:#A41E35;\">\"#{query}\"</span> returned #{count} results"
  end
end
