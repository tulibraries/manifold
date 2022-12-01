# frozen_string_literal: true

Rails.application.config.after_initialize do
  Alert.publish_json("public/assets/alerts.json")
end
