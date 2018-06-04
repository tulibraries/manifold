class Accounts::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def google_oauth2
		# You need to implement the method below in your model (e.g. app/models/account.rb)
		@account = Account.from_omniauth(request.env['omniauth.auth'])

    # [TODO] Refactor this if/elsif/else
		if @account.nil?
      flash[:alert] = "User or password not found"
      # [TODO] Temporary redirection - so we can see the error message
      redirect_to buildings_path #
	  elsif @account.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @account, event: :authentication
    else
      flash[:alert] = "User or password not found"
      # [TODO] Temporary redirection - so we can see the error message
      redirect_to buildings_path 
		end
	end
end
