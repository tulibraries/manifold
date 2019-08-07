# frozen_string_literal: true

class RedirectsController < ApplicationController
  def show
    if params[:path]
      redirect = Redirect.find_by_legacy_path(params[:path])
      if redirect
        message =
        "#{request.env['HTTP_HOST']}/#{params[:path]} has moved. \
        Please update bookmarks and links"
        redirect_to(redirect.path,
                    status: 301,
                    notice: message
                     )
      else
        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
end
