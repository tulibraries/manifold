# frozen_string_literal: true

module Admin
  class SpacesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    private
      def resource_params
        params.require(:space).permit(:draft_description, :publish)
      end
  end
end
