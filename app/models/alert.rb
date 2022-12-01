# frozen_string_literal: true

class Alert < ApplicationRecord
  has_paper_trail
  has_rich_text :description

  def self.publish_json(file)
    published_alerts = Alert.where(published: true)
    file.write(AlertSerializer.new(published_alerts).serializable_hash.to_json)
  end
end
