# frozen_string_literal: true

module Admin
  class SpacesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    def permitted_attributes
      super + [:draft_description, :publish, :accessibility]
    end
  end
end
