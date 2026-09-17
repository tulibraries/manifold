# frozen_string_literal: true

require "rails_helper"

RSpec.describe VcrSanitizer do
  subject(:sanitize) { described_class.call(interaction) }

  let(:interaction) do
    instance_double(
      VCR::HTTPInteraction,
      request: request,
      response: response
    )
  end

  let(:request) do
    instance_double(
      VCR::Request,
      headers: {
        "authorization" => ["Bearer secret-jwt"],
        "COOKIE" => ["session=secret-cookie"],
        "x-api-KEY" => ["secret-api-key"],
        "API-key" => ["secret-api-key-alt"],
        "Accept" => ["application/json"]
      }
    )
  end

  let(:response) do
    instance_double(
      VCR::Response,
      headers: {
        "set-cookie" => ["session=secret-response-cookie"],
        "Content-Type" => ["application/json"]
      },
      body: <<~JSON.chomp
        {"access_token":"secret-access-token","refresh_token":"secret-refresh-token","api_key":"secret-body-api-key"}
      JSON
    )
  end

  it "removes sensitive authentication data" do
    sanitize

    sensitive_request_headers = %w[authorization cookie x-api-key api-key]

    expect(request.headers.keys.map(&:downcase))
      .not_to include(*sensitive_request_headers)

    expect(response.headers.keys.map(&:downcase))
      .not_to include("set-cookie")

    expect(response.body).to eq(
      '{"access_token":"<redacted>","refresh_token":"<redacted>","api_key":"<redacted>"}'
    )

    expect(request.headers["Accept"]).to eq(["application/json"])
    expect(response.headers["Content-Type"]).to eq(["application/json"])
  end
end
