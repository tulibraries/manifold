# frozen_string_literal: true

module VcrSanitizer
  module_function

  def call(interaction)
    interaction.request.headers.delete("Authorization")
    interaction.request.headers.delete("Cookie")
    interaction.request.headers.delete("X-API-Key")
    interaction.request.headers.delete("Api-Key")
    interaction.response.headers.delete("Set-Cookie")

    body = interaction.response.body

    return unless body&.match?(/"(access_token|refresh_token|api_key)"\s*:/)

    body.gsub!(
      /"(access_token|refresh_token|api_key)"\s*:\s*"[^"]+"/,
      '"\1":"<redacted>"'
    )
  end
end
