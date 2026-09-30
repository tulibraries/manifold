# frozen_string_literal: true

class Panopto::PastEventsCollectionComponent < ViewComponent::Base
  def initialize(videos:)
    @collection = videos[0]
    @videos = videos[1]
    @retrieval_failed = videos[2] == :retrieval_failed
  end
end
