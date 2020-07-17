# frozen_string_literal: true

class AlertSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  attributes :published, :scroll_text, :link, :description, :updated_at
end
