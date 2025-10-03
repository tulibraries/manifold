# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions" do
  before(:all) do
    @admin = FactoryBot.create(:administrator)
    @account = FactoryBot.create(:account)
  end

  context "admin user" do
    it "signs admin in" do
      sign_in @admin
      get admin_root_path
      expect(response).to have_http_status(:redirect)
      follow_redirect!
      expect(response).to have_http_status(200)
      sign_out @admin
    end

    it "No sign in" do
      get admin_root_path
      expect(response).to_not have_http_status(200)
    end

    it "shouldn't sees accounts choice" do
      sign_in @admin
      get admin_root_path
      follow_redirect!
      expect(response.body).to match("Account")
      sign_out @admin
    end

    it "administers accounts" do
      sign_in @admin
      response_code = get(admin_accounts_path)
      expect(response_code).to eq(200)
      sign_out @admin
    end
  end

  context "Regular User" do
    describe "may access main admin" do
      it "signs account in" do
        sign_in @account
        get admin_root_path
        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(200)
        sign_out @account
      end

      it "signs account out" do
        get admin_root_path
        expect(response).to_not have_http_status(200)
      end

      it "sees accounts" do
        sign_in @account
        get admin_accounts_path
        # Regular account should be redirected when trying to access accounts
        expect(response).to have_http_status(:redirect)
        sign_out @account
      end
    end
  end

end
