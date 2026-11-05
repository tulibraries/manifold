# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.before_action :authenticate_account!
end
