# frozen_string_literal: true

module RedirectLogic
  extend ActiveSupport::Concern

  def redirect_or_404(instance = nil)
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
      if Rails.application.routes.recognize_path(legacy_path)
        if instance
          return
        else
          raise ActionController::RoutingError.new("Not Found")
        end
      else
        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end

  def legacy_path
    request.fullpath
  end
end
