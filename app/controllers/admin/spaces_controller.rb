# frozen_string_literal: true

module Admin
  class SpacesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    rescue_from ActiveRecord::DeleteRestrictionError  do |exception|
      notice = @requested_resource.cannot_destroy_message(exception)
      redirect_back(fallback_location: admin_spaces_path, notice:)
    end

    def permitted_attributes
      super + [:draft_description, :publish, :accessibility]
    end
  end
end
