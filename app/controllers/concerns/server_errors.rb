# frozen_string_literal: true

module ServerErrors
  extend ActiveSupport::Concern

  included do
    next unless ENV['MANIFOLD_RESCUE_FROM_DB_ERRORS']

    rescue_from PG::Error do |exception|
      message = "#{exception.message} \n #{exception.backtrace[0]}"
      Honeybadger.notify(message)
      @alert = nil
      render "webpages/home", status: :internal_server_error
    end
  end
end
