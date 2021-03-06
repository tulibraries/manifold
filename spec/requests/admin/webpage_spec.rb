# frozen_string_literal: true

require "rails_helper"

RSpec.describe Webpage, type: :request do
  it_behaves_like "renderable_dashboard"

  describe "GET /webpage/:id/detach" do
    it "detaches document from page" do
      page = FactoryBot.create(:webpage)
      login_as(FactoryBot.create(:administrator), scope: :account)

      get "/admin/webpages/#{page.id}/edit"
      expect(response).to render_template(:edit)
    end
  end
end
