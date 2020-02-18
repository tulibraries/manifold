# frozen_string_literal: true

module Admin
  class BuildingsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    private
      def resource_params
        params.require(:building).permit(:draft_description, :publish)
      end
  end
end
