# frozen_string_literal: true

module RedirectLogic
  extend ActiveSupport::Concern

  def redirect_or_404
    redirect = Redirect.find_by(legacy_path: legacy_path)
    if redirect
      unless redirect.no_message
        message =
        "#{request.host}#{legacy_path} #{t('manifold.redirects.moved_permanently')}"
      end
      redirect_to(url_for(redirect.path),
                  status: :moved_permanently,
                  notice: message
                  )
    else
      raise ActionController::RoutingError.new("Not Found")
    end
  end

  def legacy_path
    binding.pry
    request.fullpath
  end
end
