# frozen_string_literal: true

Rails.application.config.after_initialize do
  Publish::Alerts.publish
#  system("mkdir", "-p", "public/assets") unless File.directory?("public/assets")
#  Alert.publish_json(File.open("public/assets/alerts.json", "w"))
   File.open("public/assets/alerts.json", "w") { |file| file.write('{"data":[]}') }
end
