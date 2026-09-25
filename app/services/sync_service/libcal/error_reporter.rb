# frozen_string_literal: true

require "uri"

class SyncService::Libcal::ErrorReporter
  SENSITIVE_PARAM_NAMES = %w[accesstoken token apikey key secret password clientid clientsecret].freeze

  USERINFO = %r{://[^/?#@\s"'<>]*@}
  PARAM = /(?<=[?&;\s"']|\A)([^=&#;?\s"'<>]+)=([^&#;\s"'<>]*)/
  REDACTED = "[FILTERED]"
  MAX_DECODE_PASSES = 3
  MAX_CAUSES = 5

  def initialize(logger:)
    @logger = logger
  end

  def log(message)
    @logger.call(redact(message))
  end

  def report(err, message:, context: {})
    reported = redacted_exception(err)
    log(message)
    Honeybadger.notify(reported, context: context.transform_values { |value| value.is_a?(String) ? redact(value) : value })
    reported
  end

  def redact_sources(sources)
    Array(sources).map { |source| redact(source) }.join(", ")
  end

  def redact(text)
    text.to_s
      .gsub(USERINFO, "://")
      .gsub(PARAM) do
        match = Regexp.last_match
        sensitive_name?(match[1]) ? "#{match[1]}=#{REDACTED}" : match[0]
      end
  end

  private

    def redacted_exception(err, depth = 0)
      return err if err.nil? || depth > MAX_CAUSES

      cause = redacted_exception(err.cause, depth + 1)
      message = redact(err.message)
      return err if message == err.message && cause.equal?(err.cause)

      target = err.frozen? ? err.dup : err
      if message != target.message
        target.define_singleton_method(:message) { message }
        target.define_singleton_method(:to_s) { message }
      end
      relink_cause(target, cause) unless target.cause.equal?(cause)
      target
    end

    def relink_cause(exception, cause)
      raise exception, cause:
    rescue exception.class
      exception
    end

    def sensitive_name?(name)
      SENSITIVE_PARAM_NAMES.include?(decode(name).downcase.gsub(/[^a-z0-9]/, ""))
    end

    def decode(name)
      MAX_DECODE_PASSES.times do
        decoded = URI.decode_www_form_component(name)
        break if decoded == name

        name = decoded
      rescue ArgumentError
        break
      end
      name
    end
end
