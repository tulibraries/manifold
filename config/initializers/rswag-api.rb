# frozen_string_literal: true

Rswag::Api.configure do |c|

  # Specify a root folder where Swagger JSON files are located
  # This is used by the Swagger middleware to serve requests for API descriptions
  # NOTE: If you're using rswag-specs to generate Swagger, you'll need to ensure
  # that it's configured to generate files in the same folder
  c.openapi_root = Rails.root.to_s + "/swagger"

  c.swagger_filter = lambda { |swagger, env| swagger["host"] = env["HTTP_HOST"] }
end

Rswag::Ui.configure do |c|
  c.openapi_endpoint "/swagger.json", "API V1 Docs"
end
