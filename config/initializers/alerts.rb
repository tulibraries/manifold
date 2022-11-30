# frozen_string_literal: true

Rails.application.config.after_initialize do
  published_alerts = Alert.where(published: true)
  File.open("public/assets/alerts.json", "w") { |file| file.write(AlertSerializer.new(published_alerts).serializable_hash.to_json) }
end
