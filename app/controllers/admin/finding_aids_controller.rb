# frozen_string_literal: true

module Admin
  class FindingAidsController < Admin::ApplicationController
    include Admin::Draftable

    private
      def resource_params
        params.require(:finding_aid).permit(:draft_description, :publish)
      end
  end
end
