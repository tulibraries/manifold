# frozen_string_literal: true

class Google::EtextbooksComponent < ViewComponent::Base
  def initialize(etexts:, title:, description:)
    @etexts = etexts&.values
    @title = title
    @description = description
    @base_url = Rails.application.config.search_catalog
  end
end
