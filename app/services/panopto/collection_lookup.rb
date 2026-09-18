# frozen_string_literal: true

module Panopto
  class CollectionLookup < ApplicationService
    def initialize(collection)
      @collection = collection
    end

    def call
      return if @collection.blank?

      videos = VideoDistributor.call(
        type: "collection",
        collection: @collection
      )

      videos if videos.present?
    end
  end
end
