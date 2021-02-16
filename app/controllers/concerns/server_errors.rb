# frozen_string_literal: true

module ServerErrors
  extend ActiveSupport::Concern

  included do
    next unless ENV["MANIFOLD_RESCUE_FROM_DB_ERRORS"]

    rescue_from PG::Error do |exception|
      message = "#{exception.message} \n #{exception.backtrace[0]}"
      Honeybadger.notify(message)
      render status: :service_unavailable
    end
  end
end
