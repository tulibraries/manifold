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
        "Authorization" => ["Bearer secret-jwt"],
        "Cookie" => ["session=secret-cookie"],
        "X-API-Key" => ["secret-api-key"],
        "Api-Key" => ["secret-api-key-alt"],
        "Accept" => ["application/json"]
      }
    )
  end

  let(:response) do
    instance_double(
      VCR::Response,
      headers: {
        "Set-Cookie" => ["session=secret-response-cookie"],
        "Content-Type" => ["application/json"]
      },
      body: <<~JSON.chomp
        {"access_token":"secret-access-token","refresh_token":"secret-refresh-token","api_key":"secret-body-api-key"}
      JSON
    )
  end

  it "removes sensitive authentication data" do
    sanitize

    expect(request.headers).not_to have_key("Authorization")
    expect(request.headers).not_to have_key("Cookie")
    expect(request.headers).not_to have_key("X-API-Key")
    expect(request.headers).not_to have_key("Api-Key")
    expect(response.headers).not_to have_key("Set-Cookie")

    expect(response.body).to eq(
      '{"access_token":"<redacted>","refresh_token":"<redacted>","api_key":"<redacted>"}'
    )

    expect(request.headers["Accept"]).to eq(["application/json"])
    expect(response.headers["Content-Type"]).to eq(["application/json"])
  end
end
