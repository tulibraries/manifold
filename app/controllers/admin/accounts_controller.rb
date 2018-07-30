module Admin
  class AccountsController < Admin::ApplicationController
    load_and_authorize_resource

    # Devise has current_user hard_coded so if we us anything other than
    # user, we have no access to the devise object. So, we need to override
    # current_user to return the current account. This is needed both
    # in ApplicationController and in Admin::ApplicationController
    def current_user
      current_account
    end

    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Account.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Account.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
    
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to admin_root_url, alert: t('fortytude.error.access_denied')
    end
  end
end
