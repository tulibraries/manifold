# frozen_string_literal: true

require "pry-rails"

class Alert < ApplicationRecord
  has_paper_trail
  has_rich_text :description

  def self.publish_json(filename)
    published_alerts = Alert.where(published: true)
    File.open(filename, "w") { |file| file.write(AlertSerializer.new(published_alerts).serializable_hash.to_json) }
  end
end
