# frozen_string_literal: true

require "net/http"

module Cloudflare
  # Server-side Turnstile token validation, following Cloudflare's canonical
  # siteverify contract: reject unless siteverify returns success AND the
  # token was issued for the expected action AND an approved hostname.
  class TurnstileVerifier
    VERIFY_URI = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")
    MAX_TOKEN_LENGTH = 2048
    TIMEOUT_SECONDS = 10
    # siteverify error codes that point at our configuration or at Cloudflare,
    # not at the visitor. Visitor-caused codes (invalid-input-response,
    # timeout-or-duplicate) are logged only, so bot traffic does not page us.
    SERVER_ERROR_CODES = %w[missing-input-secret invalid-input-secret internal-error].freeze
    # Cloudflare's documented dummy secret keys, used for local development.
    # https://developers.cloudflare.com/turnstile/troubleshooting/testing/
    TEST_SECRET_KEYS = %w[
      1x0000000000000000000000000000000AA
      2x0000000000000000000000000000000AA
      3x0000000000000000000000000000000AA
    ].freeze

    def self.config
      Rails.configuration.turnstile.with_indifferent_access
    end

    def self.enabled?
      Flipflop.cloudflare_turnstile?
    end

    # Everything the server needs to validate a token. When Turnstile is
    # enabled but this is false, submissions are rejected (fail closed).
    def self.configured?
      site_key.present? && secret_key.present? && expected_hostnames.any?
    end

    def self.site_key
      config[:site_key]
    end

    def self.secret_key
      config[:secret_key]
    end

    # Frontend hostnames this deployment accepts tokens from, e.g.
    # "library.temple.edu". Production must not include localhost.
    def self.expected_hostnames
      config[:hostnames].to_s.split(",").map(&:strip).reject(&:blank?)
    end

    def self.verify(token:, remote_ip:, action:)
      unless configured?
        message = "Cloudflare Turnstile is enabled but not configured; rejecting submission"
        Rails.logger.error(message)
        report(message, context: {
          site_key_present: site_key.present?,
          secret_key_present: secret_key.present?,
          hostnames_present: expected_hostnames.any?
        })
        return false
      end
      return false unless token.is_a?(String) && token.present? && token.length <= MAX_TOKEN_LENGTH

      result = siteverify(token:, remote_ip:)
      return true if accepted?(result, action)

      details = {
        success: result["success"],
        error_codes: Array(result["error-codes"]),
        hostname: result["hostname"],
        action: result["action"],
        expected_action: action
      }
      message = "Cloudflare Turnstile rejected token"
      Rails.logger.warn("#{message}: #{details.map { |k, v| "#{k}=#{v.inspect}" }.join(' ')}")
      report(message, context: details) if server_side_rejection?(result)
      false
    rescue StandardError => e
      message = "Cloudflare Turnstile verification failed: #{e.class} - #{e.message}"
      Rails.logger.warn(message)
      report(message, context: { exception_class: e.class.name })
      false
    end

    def self.accepted?(result, action)
      result["success"] == true &&
        expected_hostnames.include?(result["hostname"]) &&
        (result["action"] == action || test_secret_key?)
    end

    # A valid token rejected for hostname or action, or a secret/Cloudflare
    # error code, means our deployment is misconfigured.
    def self.server_side_rejection?(result)
      return true if (Array(result["error-codes"]) & SERVER_ERROR_CODES).any?

      result["success"] == true
    end

    def self.report(message, context:)
      Honeybadger.notify(message, error_class: "Cloudflare::TurnstileVerifier", context:)
    end

    # Cloudflare's dummy keys always report action "test", whatever the widget
    # sent, so the action check cannot pass locally. Skip it for those keys
    # outside production; production still requires a matching action.
    def self.test_secret_key?
      !Rails.env.production? && TEST_SECRET_KEYS.include?(secret_key.to_s)
    end

    def self.siteverify(token:, remote_ip:)
      http = Net::HTTP.new(VERIFY_URI.host, VERIFY_URI.port)
      http.use_ssl = true
      http.open_timeout = TIMEOUT_SECONDS
      http.read_timeout = TIMEOUT_SECONDS
      http.write_timeout = TIMEOUT_SECONDS

      request = Net::HTTP::Post.new(VERIFY_URI)
      request.set_form_data("secret" => secret_key, "response" => token, "remoteip" => remote_ip)

      response = http.request(request)
      raise "siteverify returned HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body)
    end

    private_class_method :accepted?, :server_side_rejection?, :report, :test_secret_key?, :siteverify
  end
end
