# frozen_string_literal: true

class AlertSerializer
  include FastJsonapi::ObjectSerializer

  attributes :published, :scroll_text, :link, :link_text, :for_header, :description, :updated_at
end
