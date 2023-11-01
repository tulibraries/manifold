# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::AccountsController, type: :controller do
  # Verify edit page for non-versioned model

  let(:account) { FactoryBot.create(:account, admin: true) }
  let(:account2) { FactoryBot.create(:account, admin: true) }
  let!(:form_info) { FactoryBot.create(:form_info, recipients: [account2.email]) }

  describe "GET #edit" do
    render_views true
    it "renders edit form" do
      sign_in(account)
      get :edit, params: { id: account.to_param }
      expect(response).to be_successful
    end
  end

  describe "DELETE #destroy" do
    render_views true
    it "does not allow account to be deleted if attached to form_info model instance" do
      sign_in(account)
      expect { delete :destroy, params: { id: account2.id } }.to_not change(Account, :count)
      expect { flash[:notice].to match form_info.slug }
    end
  end
end
