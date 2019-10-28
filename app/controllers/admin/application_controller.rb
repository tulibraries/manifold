# frozen_string_literal: true

# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_account!
    before_action :set_paper_trail_whodunnit
    before_action :use_version, only: [:edit]

    helper_method :required?
    helper_method :admin_only?
    helper_method :user_editable_field?

    def required?(attribute)
      "required" if attribute.required?
    end

    def admin_only?(attribute)
      attribute.admin_only?
    end

    def user_editable_field?(account, attribute)
      !admin_only?(attribute) || account.admin
    end

    def authenticate_admin
      # TODO Add authentication logic here.
    end

    def use_version
      if params.has_key?(:version) && requested_resource.respond_to?(:versions)
        selected_version = requested_resource.versions.find_by_id(params[:version])&.reify || requested_resource
        @requested_resource = selected_version
      end
    end

    def find_resource(param)
      scoped_resource.friendly.find(param)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    protected
      def current_user
        current_account
      end
  end
end
