module ApplicationHelper
  def google_oauth_redirect_uri
    ENV.fetch("GOOGLE_OAUTH_REDIRECT_URI") { "http://localhost:3000/accounts/auth/google_oauth2" }
  end
end
