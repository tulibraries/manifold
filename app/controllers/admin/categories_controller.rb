# frozen_string_literal: true

module Admin
  class CategoriesController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    private
      def resource_params
        params.require(:category).permit(:draft_long_description, :publish)
      end
  end
end
