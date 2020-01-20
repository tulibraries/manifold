#frozen_string_literal: true

module Admin
  class PoliciesController < Admin::ApplicationController
    include Admin::Draftable

    private
      def resource_params
        params.require(:policy).permit(:draft_description, :publish)
      end
  end
end
