# frozen_string_literal: true

module Admin
  class ExhibitionsController < Admin::ApplicationController
    include Admin::Detachable

		def create
			@exhibition = Exhibition.new(exhibition_params)
			requested_resource.apply_draft if exhibition_params[:publish]
      super
		end

    def update
			requested_resource.assign_attributes(exhibition_params)
			requested_resource.apply_draft if exhibition_params[:publish]
      super
   end

    private
      def set_exhibition
        @exhibition= Exhibition.find(params[:id])
      end

      def exhibition_params
        params.require(:exhibition).permit(:draft_title, :draft_description, :publish)
      end
  end
end
