# frozen_string_literal: true

module Admin
  class WebpagesController < Admin::ApplicationController
    include Admin::Draftable
    def permitted_attributes
      super + [:publish, fileabilties_attributes: [:weight, :id]]
    end
  end
end
