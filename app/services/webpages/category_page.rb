# frozen_string_literal: true

module Webpages
  class CategoryPage < ApplicationService
    def initialize(slug)
      @slug = slug
    end

    def call
      Category.find_by(slug: @slug).items.select { |item| item.class == Category }
    end
  end
end
