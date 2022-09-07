# frozen_string_literal: true

module Admin
  class AlertsController < Admin::ApplicationController
    after_action :create_json_file, only: [:update, :destroy, :create]
    
    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, "published"),
        params.fetch(resource_name, {}).fetch(:direction, "desc"),
      )
    end

    # Devise has current_user hard_coded so if we us anything other than
    # user, we have no access to the devise object. So, we need to override
    # current_user to return the current account. This is needed both
    # in ApplicationController and in Admin::ApplicationController
    def current_user
      current_account
    end
    def find_resource(param)
      scoped_resource.find(param)
    end

    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Alert.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Alert.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_root_url, alert: t("manifold.error.modification_denied", class: "Alert")
    end

    private
    def create_json_file
      published_alerts = Alert.where(published: true)
      File.open("public/notifications.json", "w") { |file| file.write(published_alerts.to_json) }
    end
  end
end
