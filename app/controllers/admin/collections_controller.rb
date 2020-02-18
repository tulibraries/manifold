# frozen_string_literal: true

module Admin
  class CollectionsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    private
      def resource_params
        params.require(:collection).permit(:draft_description, :publish)
      end
  end
end
