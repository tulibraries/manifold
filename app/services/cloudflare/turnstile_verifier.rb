# frozen_string_literal: true

require "net/http"

module Cloudflare
  class TurnstileVerifier
    VERIFY_URI = URI("https://challenges.cloudflare.com/turnstile/v0/siteverify")

    def self.config
      Rails.configuration.turnstile.with_indifferent_access
    end

    def self.enabled?
      Flipflop.cloudflare_turnstile?
    end

    def self.configured?
      enabled? && site_key.present? && secret_key.present?
    end

    def self.site_key
      config[:sitekey]
    end

    def self.secret_key
      config[:secret_key]
    end

    def self.verify(token:, remote_ip:)
      return false unless configured?
      return false if token.blank?

      response = Net::HTTP.post_form(
        VERIFY_URI,
        {
          "secret" => secret_key,
          "response" => token,
          "remoteip" => remote_ip
        }
      )

      JSON.parse(response.body).fetch("success", false)
    rescue JSON::ParserError, StandardError => e
      Rails.logger.warn("Cloudflare Turnstile verification failed: #{e.class} - #{e.message}")
      false
    end
  end
end
