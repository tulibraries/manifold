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
    before_action :check_admin_access!
    before_action :set_paper_trail_whodunnit

    # Override Administrate's built-in authorization
    before_action :authorize_resource!, except: [:root]
    before_action :use_version, only: [:edit]
    before_action :non_editable_titles, only: [:edit]
    before_action :populate_drafts, only: [:edit]

    helper_method :required?
    helper_method :admin_only?
    helper_method :user_editable_field?
    helper_method :current_user, :signed_in?, :is_admin?
    helper_method :authorized_action?


    # Skip the admin access check for the root action since it handles its own redirect logic
    skip_before_action :check_admin_access!, only: [:root]

    def root
      # Redirect Form Submission-only users to their landing page
      if current_account.student?
        redirect_to admin_webpages_path
      elsif current_account.admin_group&.managed_entities == ["FormSubmission"]
        redirect_to admin_form_submissions_path
      else
        # Default behavior - redirect to people index (users can read/index people)
        redirect_to admin_people_path
      end
    end

    def resource_params
      params.require(resource_name).permit(dashboard.permitted_attributes)
    end

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
      !admin_only?(attribute) || account.admin?
    end

    def check_admin_access!
      # Basic check - ensure user is authenticated
      # All authenticated users can access admin interface (with appropriate restrictions)
      # The detailed authorization is handled by authorize_resource!
      unless current_account
        redirect_to root_path, alert: "You must be logged in to access the admin area."
        return false
      end

      return true
    end

    def authorize_resource!
      resource_type = controller_name.classify.constantize rescue nil
      return unless resource_type

      case action_name
      when "index", "show"
        authorize! :read, resource_type
      when "new", "create"
        authorize! :create, resource_type
      when "edit", "update"
        if params[:id].present?
          resource = resource_type.find(params[:id])
          authorize! :update, resource
        else
          authorize! :update, resource_type
        end
      when "destroy"
        if params[:id].present?
          resource = resource_type.find(params[:id])
          authorize! :destroy, resource
        else
          authorize! :destroy, resource_type
        end
      else
        authorize! :manage, resource_type
      end
    rescue CanCan::AccessDenied => exception
      # Redirect FormSubmission-only users to their allowed area
      if current_account.student?
        redirect_to admin_webpages_path, alert: exception.message
      elsif current_account.admin_group&.managed_entities == ["FormSubmission"]
        redirect_to admin_form_submissions_path, alert: "You are not authorized to access this page"
      else
        # Redirect other users to people index which all authenticated users can access
        redirect_to admin_people_path, alert: exception.message
      end
    end

    # Override Administrate's authorize_resource method (for navigation and view helpers)
    def authorize_resource(resource)
      resource_class = resource.is_a?(Class) ? resource : resource.class

      case action_name
      when "index", "show"
        authorize! :read, resource_class
      when "new", "create"
        authorize! :create, resource_class
      when "edit", "update"
        authorize! :update, resource_class
      when "destroy"
        authorize! :destroy, resource_class
      else
        authorize! :manage, resource_class
      end

      return resource
    rescue CanCan::AccessDenied => exception
      # This method is used by navigation helpers, so we don't redirect here
      raise exception
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def signed_in?
      !!current_user
    end

    def is_admin?
      signed_in? ? current_user.admin? : false
    end

    def authorized_action?(resource_class, action)
      case action
      when :index, :show
        can?(:read, :all) || can?(:read, resource_class)
      when :new, :create
        can?(:create, :all) || can?(:manage, :all) || can?(:create, resource_class)
      when :edit, :update
        can?(:update, :all) || can?(:manage, :all) || can?(:update, resource_class)
      when :destroy
        can?(:destroy, :all) || can?(:manage, :all) || can?(:destroy, resource_class)
      else
        can?(:manage, :all) || can?(:manage, resource_class)
      end
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

    def populate_drafts
      if requested_resource.respond_to?(:description) && [:category, :event, :alert, :group, :application_failover, :snippet].exclude?(resource_name.to_sym)
        requested_resource.draft_description.present? ? requested_resource.draft_description :
          (requested_resource.draft_description = requested_resource.description)
      end

      if requested_resource.respond_to?(:long_description)
        requested_resource.draft_long_description.present? ? requested_resource.draft_long_description :
          (requested_resource.draft_long_description = requested_resource.long_description)
      end

      if requested_resource.respond_to?(:access_description)
        requested_resource.draft_access_description.present? ? requested_resource.draft_access_description :
          (requested_resource.draft_access_description = requested_resource.access_description)
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
