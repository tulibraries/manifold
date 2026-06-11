# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Flipflop dashboard", type: :request do
  describe "GET /flipflop" do
    context "when not signed in" do
      it "redirects to sign in" do
        get "/flipflop"
        expect(response).to redirect_to(new_account_session_path)
      end
    end

    context "when signed in as a non-admin" do
      before { sign_in FactoryBot.create(:account) }

      it "returns 404" do
        get "/flipflop"
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when signed in as an admin" do
      before { sign_in FactoryBot.create(:account, role: "admin") }

      it "renders the dashboard" do
        get "/flipflop"
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
