# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  def initialize(etexts:)
    @etexts = etexts&.values
    @intro = Snippet.friendly.find("past-event-videos-intro")
    @base_url = Rails.application.config.search_catalog
  end
end
