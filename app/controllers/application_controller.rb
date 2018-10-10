# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Devise has current_user hard_coded so if we us anything other than
  # user, we have no access to the devise object. So, we need to override
  # current_user to return the current account. This is needed both
  # in ApplicationController and in Admin::ApplicationController
  before_action :get_alert

  def current_user
    current_account
  end

  def get_alert
    @alert = Alert.where(published: true)
  end
end
