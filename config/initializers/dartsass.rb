# frozen_string_literal: true

Rails.application.configure do
  bootstrap_stylesheets = File.join(Gem.loaded_specs.fetch("bootstrap").full_gem_path, "assets/stylesheets")

  config.dartsass.builds = {
    "application.css.scss" => "application.css",
    "administrate/application.scss" => "administrate/application.css"
  }

  config.dartsass.build_options = ["--no-source-map", "--load-path=#{bootstrap_stylesheets}"]
end
