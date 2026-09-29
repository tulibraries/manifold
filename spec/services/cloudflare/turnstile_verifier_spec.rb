# frozen_string_literal: true

require "rails_helper"

RSpec.describe Cloudflare::TurnstileVerifier do
  let(:verify_url) { described_class::VERIFY_URI.to_s }
  let(:hostnames) { "library.temple.edu, www.library.temple.edu" }
  let(:config) { { site_key: "site-key", secret_key: "secret-key", hostnames: } }
  let(:siteverify_result) do
    { "success" => true, "hostname" => "library.temple.edu", "action" => "ir", "error-codes" => [] }
  end

  before do
    allow(Honeybadger).to receive(:notify)
    allow(described_class).to receive(:config) { config.with_indifferent_access }
    stub_request(:post, verify_url).to_return do
      { status: 200, body: siteverify_result.to_json, headers: { "Content-Type" => "application/json" } }
    end
  end

  def verify(token: "token", action: "ir")
    described_class.verify(token:, remote_ip: "203.0.113.5", action:)
  end

  describe ".configured?" do
    it "requires site key, secret key, and at least one hostname" do
      expect(described_class.configured?).to be(true)

      config[:hostnames] = " , "
      expect(described_class.configured?).to be(false)
    end
  end

  describe ".expected_hostnames" do
    it "splits and trims the comma-separated list" do
      expect(described_class.expected_hostnames).to eq(%w[library.temple.edu www.library.temple.edu])
    end
  end

  describe ".verify" do
    it "calls siteverify with the secret, token, and client IP" do
      expect(verify).to be(true)

      expect(WebMock).to have_requested(:post, verify_url)
        .with(body: { "secret" => "secret-key", "response" => "token", "remoteip" => "203.0.113.5" })
        .once
    end

    it "rejects without calling siteverify when not configured" do
      config[:secret_key] = nil

      expect(verify).to be(false)
      expect(WebMock).not_to have_requested(:post, verify_url)
    end

    it "rejects blank, non-string, and oversized tokens without calling siteverify" do
      expect(verify(token: "")).to be(false)
      expect(verify(token: nil)).to be(false)
      expect(verify(token: ["token"])).to be(false)
      expect(verify(token: "a" * 2049)).to be(false)
      expect(WebMock).not_to have_requested(:post, verify_url)
    end

    it "rejects when siteverify reports failure" do
      siteverify_result.merge!("success" => false, "error-codes" => ["timeout-or-duplicate"])

      expect(verify).to be(false)
    end

    it "rejects a token issued for a different action" do
      expect(verify(action: "missing-book")).to be(false)
    end

    it "rejects a token issued for an unapproved hostname" do
      siteverify_result["hostname"] = "evil.example.com"

      expect(verify).to be(false)
    end

    it "rejects when siteverify returns a non-success HTTP status" do
      stub_request(:post, verify_url).to_return(status: 500, body: siteverify_result.to_json)

      expect(verify).to be(false)
    end

    it "rejects when siteverify times out" do
      stub_request(:post, verify_url).to_timeout

      expect(verify).to be(false)
    end

    it "rejects when siteverify returns invalid JSON" do
      stub_request(:post, verify_url).to_return(status: 200, body: "not json")

      expect(verify).to be(false)
    end

    describe "Honeybadger reporting" do
      def expect_reported(message, context)
        expect(Honeybadger).to have_received(:notify).with(
          a_string_starting_with(message),
          error_class: "Cloudflare::TurnstileVerifier",
          context: hash_including(context)
        ).once
      end

      it "does not report accepted tokens" do
        expect(verify).to be(true)
        expect(Honeybadger).not_to have_received(:notify)
      end

      it "reports when Turnstile is not configured" do
        config[:secret_key] = nil

        verify

        expect_reported(
          "Cloudflare Turnstile is enabled but not configured",
          site_key_present: true, secret_key_present: false, hostnames_present: true
        )
      end

      it "reports an invalid secret" do
        siteverify_result.merge!("success" => false, "error-codes" => ["invalid-input-secret"])

        verify

        expect_reported("Cloudflare Turnstile rejected token", error_codes: ["invalid-input-secret"])
      end

      it "reports a Cloudflare internal error" do
        siteverify_result.merge!("success" => false, "error-codes" => ["internal-error"])

        verify

        expect_reported("Cloudflare Turnstile rejected token", error_codes: ["internal-error"])
      end

      it "reports a valid token from an unapproved hostname" do
        siteverify_result["hostname"] = "manifold-qa.k8s.temple.edu"

        verify

        expect_reported("Cloudflare Turnstile rejected token", hostname: "manifold-qa.k8s.temple.edu")
      end

      it "reports a valid token issued for a different action" do
        verify(action: "missing-book")

        expect_reported("Cloudflare Turnstile rejected token", action: "ir", expected_action: "missing-book")
      end

      it "reports timeouts and non-success HTTP responses" do
        stub_request(:post, verify_url).to_timeout
        verify
        expect_reported("Cloudflare Turnstile verification failed", {})

        stub_request(:post, verify_url).to_return(status: 500, body: "")
        verify
        expect(Honeybadger).to have_received(:notify).twice
      end

      it "only logs visitor-caused rejections" do
        %w[invalid-input-response timeout-or-duplicate].each do |code|
          siteverify_result.merge!("success" => false, "error-codes" => [code])
          expect(verify).to be(false)
        end
        expect(verify(token: "")).to be(false)

        expect(Honeybadger).not_to have_received(:notify)
      end

      it "never sends the token or secret" do
        siteverify_result.merge!("success" => false, "error-codes" => ["invalid-input-secret"])

        verify(token: "sensitive-token")

        expect(Honeybadger).to have_received(:notify) do |message, **options|
          payload = [message, options].inspect
          expect(payload).not_to include("sensitive-token")
          expect(payload).not_to include("secret-key")
        end
      end
    end

    context "with Cloudflare's dummy test keys" do
      # What siteverify actually returns for the dummy keys, confirmed against a
      # live local submission: hostname example.com even when the page is served
      # from localhost, and no action key at all. Cloudflare's testing docs show
      # hostname "localhost" and action "test", which is covered separately below.
      # https://developers.cloudflare.com/turnstile/troubleshooting/testing/
      let(:hostnames) { "example.com" }
      let(:siteverify_result) do
        {
          "success" => true,
          "challenge_ts" => "2022-02-28T15:14:30.096Z",
          "hostname" => "example.com",
          "error-codes" => [],
          "cdata" => "test-data"
        }
      end

      before { config[:secret_key] = described_class::TEST_SECRET_KEYS.first }

      it "accepts the response the test keys actually return" do
        expect(verify).to be(true)
      end

      it "accepts the response Cloudflare documents for the test keys" do
        siteverify_result["hostname"] = "localhost"
        siteverify_result["action"] = "test"
        config[:hostnames] = "localhost"

        expect(verify).to be(true)
      end

      it "still requires a matching action in production" do
        allow(Rails.env).to receive(:production?).and_return(true)

        expect(verify).to be(false)
      end

      it "still rejects an unapproved hostname" do
        config[:hostnames] = "library.temple.edu"

        expect(verify).to be(false)
      end

      it "rejects the same response when a real secret key is configured" do
        config[:secret_key] = "secret-key"

        expect(verify).to be(false)
      end
    end
  end
end
