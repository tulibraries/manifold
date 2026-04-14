Rails.application.configure do
  config.dartsass.builds = {
    "application.css.scss" => "application.css",
    "administrate/application.scss" => "administrate/application.css"
  }

  config.dartsass.build_options = ["--no-source-map", "--load-path=node_modules"]
end
