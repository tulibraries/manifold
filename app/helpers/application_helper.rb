module ApplicationHelper
  def google_oauth_redirect_uri
    return "#{request.env['rack.url_scheme']}://#{request.env["HTTP_HOST"]}/accounts/auth/google_oauth2"
  end
end
