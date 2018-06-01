class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
		# You need to implement the method below in your model (e.g. app/models/account.rb)
		@account = Account.from_omniauth(request.env['omniauth.auth'])

		if @account.nil?
      flash[:alert] = "User or password not found"
      redirect_to buildings_path
	  elsif @account.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @account, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_account_registration_url, alert: @account.errors.full_messages.join("\n")
		end
	end
end
