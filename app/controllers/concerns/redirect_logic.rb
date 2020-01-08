# frozen_string_literal: true

module RedirectLogic
  extend ActiveSupport::Concern

  def redirect_or_404
    redirect = Redirect.find_by(legacy_path: legacy_path)
    if redirect
      message =
      "#{request.env['HTTP_HOST']}#{legacy_path} has moved. \
      Please update bookmarks and links"
      redirect_to(redirect.path,
                  status: :moved_permanently,
                  notice: message
                  )
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def legacy_path
    request.env["REQUEST_URI"]
  end
end
