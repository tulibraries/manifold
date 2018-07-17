class ApplicationController < ActionController::Base
  def current_user
    current_account
  end
end
