# frozen_string_literal: true

class AlertSerializer
  include FastJsonapi::ObjectSerializer

  attributes :published, :scroll_text, :link, :for_header, :description, :updated_at
end
