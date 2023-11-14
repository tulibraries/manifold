# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  def initialize(etexts:, slug:)
    @etexts = etexts&.values
    intro = Snippet.friendly.find(slug)
    @title = intro ? intro.title : t("manifold.webpages.etextbooks.title")
    @intro = intro ? intro.description : t("manifold.webpages.etextbooks.description")
    @base_url = Rails.application.config.search_catalog
  end
end
