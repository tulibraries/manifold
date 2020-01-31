# frozen_string_literal: true

module Admin
  class CollectionsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable if Rails.configuration.draftable

    private
      def resource_params
        params.require(:collection).permit(:draft_description, :publish) if Rails.configuration.draftable
      end
  end
end
