# frozen_string_literal: true

module RedirectLogic
  extend ActiveSupport::Concern

  def redirect_or_404(instance = nil)
    redirect = Redirect.find_by(legacy_path:)
    if redirect
      unless redirect.no_message
        message =
        "#{request.host}#{legacy_path} #{t('manifold.redirects.moved_permanently')}"
      end
      if is_external_url?(redirect.path)
        redirect_to(redirect.path, allow_other_host: true)
      else
        redirect_to(url_for(redirect.path),
                    status: :moved_permanently,
                    notice: message
                    )
      end
    else
      if Rails.application.routes.recognize_path(legacy_path)
        if instance
          return
        else
          if legacy_path.include? "finding_aids?collection"
            redirect_to(url_for(t('manifold.default.finding_aids_new_home')), allow_other_host: true)
          else
            raise ActionController::RoutingError.new("Not Found")
          end
        end
      else
        raise ActionController::RoutingError.new("Not Found")
      end


    end
  end

  def legacy_path
    request.fullpath
  end

  def is_external_url?(url)
    true if url.is_a?(String) && url.include?("http")
  end
end
