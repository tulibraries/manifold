# frozen_string_literal: true

module Publish
  module Alerts
    def self.publish
      system("mkdir", "-p", "public/assets") unless File.directory?("public/assets")
      Alert.publish_json(File.open("public/assets/alerts.json", "w"))
    end
  end
end
