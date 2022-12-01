# frozen_string_literal: true

Rails.application.config.after_initialize do
  Alert.publish_json(File.open("public/assets/alerts.json", "w"))
end
