# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Active Storage direct uploads", type: :request do
  let(:params) do
    { blob: { filename: "test.png", byte_size: 1024,
              checksum: "1B2M2Y8AsgTpgAmY7PhCfg==", content_type: "image/png" } }
  end

  context "when not signed in" do
    it "rejects the request and creates no blob" do
      expect {
        post rails_direct_uploads_path, params:, as: :json
      }.not_to change(ActiveStorage::Blob, :count)

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "when signed in" do
    before { sign_in FactoryBot.create(:account) }

    it "creates a blob" do
      expect {
        post rails_direct_uploads_path, params:, as: :json
      }.to change(ActiveStorage::Blob, :count).by(1)

      expect(response).to have_http_status(:ok)
    end
  end
end
