# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::CollectionsController, type: :controller do
  let(:account) { FactoryBot.create(:account, admin: true) }
  let(:finding_aid) { FactoryBot.create(:finding_aid) }
  let!(:collection) { FactoryBot.create(:collection, finding_aids: [finding_aid]) }

  describe "DELETE #destroy" do
    render_views true
    it "does not allow collection deleted if finding_aids attached" do
      sign_in(account)
      expect { delete :destroy, params: { id: collection.id } }.to_not change(Collection, :count)
      expect(flash[:notice]).to match(collection.name)
    end
  end
end
