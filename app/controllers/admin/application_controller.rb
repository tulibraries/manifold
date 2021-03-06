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
    before_action :non_editable_titles, only: [:edit]

    helper_method :required?
    helper_method :admin_only?
    helper_method :user_editable_field?
    helper_method :current_user, :signed_in?, :is_admin?


    def edit
      super
    end

    def required?(attribute)
      "required" if attribute.required?
    end

    def admin_only?(attribute)
      attribute.admin_only?
    end

    def non_editable_titles
      @models = ["building", "blog", "category", "collection", "event", "exhibition", "external_link", "finding_aid", "group", "highlight", "policy", "service", "space", "webpage"]
    end

    def user_editable_field?(account, attribute)
      !admin_only?(attribute) || account.admin
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def signed_in?
      !!current_user
    end

    def is_admin?
      signed_in? ? current_user.admin : false
    end

    def use_version
      if params.has_key?(:version) && requested_resource.respond_to?(:versions)
        selected_version = requested_resource.versions.find_by(id: params[:version])&.reify || requested_resource
        @requested_resource = selected_version
      end
    end

    def find_resource(param)
      unless scoped_resource.class.to_s == "ActiveStorage::Attachment::ActiveRecord_Relation"
        scoped_resource.friendly.find(param)
      else
        scoped_resource.find(param)
      end
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
