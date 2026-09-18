# frozen_string_literal: true

module Panopto
  class VideoSearch < ApplicationService
    def initialize(query)
      @query = query
    end

    def call
      return if @query.blank?

      VideoDistributor.call(type: "search", query: @query)
    end
  end
end
