# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Libcal::ErrorReporter, type: :service do
  define_negated_matcher :exclude, :include

  subject(:reporter) { described_class.new(logger: ->(message) { logged << message }) }

  let(:logged) { [] }

  describe "#redact_sources" do
    it "leaves a LibCal source without credentials untouched" do
      source = "https://charlesstudy.temple.edu/1.1/events?cal_id=6197&date=2026-01-01&days=365&limit=500"

      expect(reporter.redact_sources([source])).to eq(source)
    end

    it "strips userinfo from a url with no query" do
      expect(reporter.redact_sources(["https://user:secret@example.com/events"]))
        .to eq("https://example.com/events")
    end

    it "strips userinfo without a password" do
      expect(reporter.redact_sources(["https://user@example.com/events"]))
        .to eq("https://example.com/events")
    end

    it "strips userinfo and filters credential params while keeping the rest" do
      redacted = reporter.redact_sources(["https://user:secret@example.com/events?cal_id=1&access_token=abc&API_KEY=def"])

      expect(redacted).to eq("https://example.com/events?cal_id=1&access_token=[FILTERED]&API_KEY=[FILTERED]")
    end

    it "filters credentials from urls that do not parse" do
      malformed = [
        "https://example.com/events?access_token=abc 123",
        "https://user:secret@exa mple.com/events?cal_id=1&token=abc",
        "https://example.com/events?cal_id=%%&client_secret=abc"
      ]

      redacted = reporter.redact_sources(malformed)

      expect(redacted).not_to include("abc")
      expect(redacted).not_to include("secret@")
    end

    it "filters encoded and differently-cased spellings of a credential name" do
      spellings = %w[access%5Ftoken access%255Ftoken ACCESS-TOKEN accessToken client%5fsecret]

      spellings.each do |name|
        expect(reporter.redact_sources(["https://example.com/events?cal_id=1&#{name}=secret"]))
          .to eq("https://example.com/events?cal_id=1&#{name}=[FILTERED]")
      end
    end

    it "continues redacting credentials after a malformed percent-encoded parameter name" do
      source = "https://example.com/events?cal%ZZid=1&access_token=secret"

      expect(reporter.redact_sources([source]))
        .to eq("https://example.com/events?cal%ZZid=1&access_token=[FILTERED]")
    end

    it "does not filter params that merely contain a sensitive name" do
      source = "https://example.com/events?monkey=1&token_type=bearer"

      expect(reporter.redact_sources([source])).to eq(source)
    end

    it "passes local paths and the response-body label through" do
      expect(reporter.redact_sources(["/tmp/events.json", "provided response body"]))
        .to eq("/tmp/events.json, provided response body")
    end
  end

  describe "#report" do
    before { allow(Honeybadger).to receive(:notify) }

    def raise_with_cause(outer, inner)
      raise ArgumentError, inner
    rescue ArgumentError
      raise URI::InvalidURIError, outer
    end

    it "logs the message and notifies Honeybadger with the given context" do
      error = StandardError.new("boom")

      reporter.report(error, message: "sync failed", context: { libcal_event_id: 1 })

      expect(logged).to eq(["sync failed"])
      expect(Honeybadger).to have_received(:notify).with(error, context: { libcal_event_id: 1 })
    end

    it "redacts the log line, the context, and the exception and its cause in place" do
      error = begin
        raise_with_cause('bad URI: "https://example.com/e?access_token=outer-secret x"',
                         "inner https://user:pw@example.com/e?api%5Fkey=inner-secret")
      rescue URI::InvalidURIError => err
        err
      end

      reporter.report(error,
        message: "aborted - #{error.message}",
        context: { libcal_event_title: "Talk https://example.com/e?token=ctx-secret", libcal_event_id: 7 })

      expect(logged.join).to include("[FILTERED]").and exclude("outer-secret")
      expect(error).to be_a(URI::InvalidURIError)
      expect([error.message, error.detailed_message(highlight: false), error.inspect].join)
        .to include("access_token=[FILTERED]").and exclude("outer-secret")
      expect(error.cause.message).to exclude("inner-secret").and exclude("user:pw")
      expect(Honeybadger).to have_received(:notify).with(
        error, context: { libcal_event_title: "Talk https://example.com/e?token=[FILTERED]", libcal_event_id: 7 }
      )
    end

    it "leaves an exception without credentials untouched" do
      error = StandardError.new("execution expired")

      reporter.report(error, message: "aborted", context: {})

      expect(error.singleton_methods).to be_empty
    end

    it "reports and returns a redacted copy of a frozen exception" do
      error = begin
        raise URI::InvalidURIError, "bad URI: https://example.com/e?token=secret"
      rescue URI::InvalidURIError => err
        err.freeze
      end

      reported = reporter.report(error, message: "aborted #{error.message}", context: {})

      expect(logged.join).to exclude("token=secret")
      expect(reported).not_to equal(error)
      expect(reported).to be_a(URI::InvalidURIError)
      expect(reported.backtrace).to eq(error.backtrace)
      expect(reported.detailed_message(highlight: false)).to include("token=[FILTERED]").and exclude("secret")
      expect(Honeybadger).to have_received(:notify).with(reported, context: {})
    end

    it "copies and relinks when only a cause is frozen" do
      error = begin
        raise_with_cause("outer, nothing sensitive", "inner https://example.com/e?token=secret")
      rescue URI::InvalidURIError => err
        err.cause.freeze
        err
      end

      reported = reporter.report(error, message: "aborted", context: {})

      expect(reported).to equal(error)
      expect(reported.cause.message).to eq("inner https://example.com/e?token=[FILTERED]")
    end

    it "redacts every cause Honeybadger sends" do
      error = (0..described_class::MAX_CAUSES).reverse_each.reduce(nil) do |cause, depth|
        begin
          raise StandardError, "depth #{depth} https://example.com/e?token=secret-#{depth}", cause:
        rescue StandardError => err
          err
        end
      end

      reported = reporter.report(error, message: "aborted", context: {})

      chain = []
      exception = reported
      (described_class::MAX_CAUSES + 1).times do
        chain << exception.message
        exception = exception.cause
      end
      expect(chain.size).to eq(6)
      expect(chain.join).to exclude("secret")
    end

    it "gives a re-raiser the redacted copy so the job-level report is clean" do
      frozen = begin
        raise URI::InvalidURIError, "bad URI: https://example.com/e?access_token=secret"
      rescue URI::InvalidURIError => err
        err.freeze
      end

      expect { raise reporter.report(frozen, message: "aborted", context: {}) }
        .to raise_error(URI::InvalidURIError) { |raised| expect(raised.message).to exclude("secret") }
    end
  end

  describe "#log" do
    it "redacts free-form messages such as image download failures" do
      reporter.log("LibCal image retrieval failure: https://cdn.example.com/a.png?Signature=x&token=secret")

      expect(logged).to eq(["LibCal image retrieval failure: https://cdn.example.com/a.png?Signature=x&token=[FILTERED]"])
    end
  end
end
