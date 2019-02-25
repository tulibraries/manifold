# frozen_string_literal: true

class EventSerializer
  include FastJsonapi::ObjectSerializer

  def self.helpers
    Rails.application.routes.url_helpers
  end

  link :self, Proc.new { |event| helpers.url_for(event) }

  attributes :title, :description, :start_time, :end_time, :content_hash
  attribute :image, if: Proc.new { |event| event.image.attached? } do |event|
    helpers.rails_blob_url(event.image)
  end

  attribute :thumbnail_image, if: Proc.new { |event| event.image.attached? } do |event|
    helpers.rails_representation_url(event.image.variant(resize: "100x100").processed)
  end
end
