# frozen_string_literal: true

module Admin
  class ExhibitionsController < Admin::ApplicationController
    include Admin::Detachable
    include Admin::Draftable

    private
      def resource_params
        params.require(:exhibition).permit(:draft_title, :draft_description, :apply_draft_fields)
      end
  end
end
