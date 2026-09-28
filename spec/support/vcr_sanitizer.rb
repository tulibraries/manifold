# frozen_string_literal: true

module VcrSanitizer
  module_function

  def call(interaction)
    sensitive_request_headers = %w[authorization cookie x-api-key api-key]

    interaction.request.headers.delete_if do |key, _|
      sensitive_request_headers.include?(key.downcase)
    end

    interaction.response.headers.delete_if do |key, _|
      key.casecmp?("set-cookie")
    end

    body = interaction.response.body

    return unless body&.match?(/"(access_token|refresh_token|api_key)"\s*:/)

    body.gsub!(
      /"(access_token|refresh_token|api_key)"\s*:\s*"[^"]+"/,
      '"\1":"<redacted>"'
    )
  end
end
