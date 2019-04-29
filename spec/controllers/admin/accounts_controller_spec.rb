# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AccountsController, type: :controller do
  # Verify edit page for non-versioned model

  describe "GET #edit" do
    render_views true
    it "renders edit form" do
      account = FactoryBot.create(:account, admin: true)
      sign_in(account)
      get :edit, params: { id: account.to_param }
      expect(response).to be_successful
    end
  end
end
