# frozen_string_literal: true

module Admin
  class ServicesController < Admin::ApplicationController
    include Admin::Draftable

    private
      def resource_params
        params.require(:service).permit(:draft_title, :draft_slug, :draft_description, :draft_access_description,
                                        :draft_access_link, :publish)
      end
  end
end
