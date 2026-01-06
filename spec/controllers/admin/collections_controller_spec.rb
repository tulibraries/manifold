# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CollectionsController, type: :controller do
  let(:account) { FactoryBot.create(:account, role: "admin") }
  let!(:collection) { FactoryBot.create(:collection) }

  describe "DELETE #destroy" do
    render_views true
    it "allows collection to be deleted" do
      sign_in(account)
      expect { delete :destroy, params: { id: collection.id } }.to change(Collection, :count).by(-1)
    end
  end
end
