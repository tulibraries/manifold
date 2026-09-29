# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncService::Libcal::AccessTokenFetcher, type: :service do
  let(:token_url) { "https://charlesstudy.temple.edu/1.1/oauth/token" }

  before do
    allow(Rails.configuration).to receive_messages(
      libcal_token_url: token_url, libcal_client_id: "client-id", libcal_client_secret: "client-secret"
    )
  end

  it "surfaces the OAuth error fields without echoing the response body" do
    stub_request(:post, token_url).to_return(
      status: 401,
      body: { error: "invalid_client", error_description: "Bad credentials", echoed: "client-secret" }.to_json
    )

    expect { described_class.new.fetch }.to raise_error(
      SyncService::LibcalEvents::MissingAccessTokenConfigurationException
    ) { |err|
      expect(err.message).to eq("Unable to fetch LibCal access token: 401 Bad credentials")
      expect(err.message).not_to include("client-secret")
    }
  end

  it "says so when the response carries no error details" do
    stub_request(:post, token_url).to_return(status: 200, body: {}.to_json)

    expect { described_class.new.fetch }.to raise_error(
      SyncService::LibcalEvents::MissingAccessTokenConfigurationException,
      "Unable to fetch LibCal access token: 200 (no error details in response)"
    )
  end
end
