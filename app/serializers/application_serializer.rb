# frozen_string_literal: true

class ApplicationSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  attributes :label, :updated_at
end
