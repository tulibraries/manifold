# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Buildings", type: :request do
  describe "GET /buildings" do
    it "shows a list of buildings" do
      skip "Are these necessary?"
      building1 = FactoryBot.create(:building)
      building2 = FactoryBot.create(:building)
      get buildings_path
      expect(response).to render_template(:index)
      expect(response.body).to include(building1.name)
      expect(response.body).to include(building2.name)
    end
  end

  describe "GET /buildings/1" do
    it "shows the first building" do
      skip "Are these necessary?"
      building1 = FactoryBot.create(:building)
      building2 = FactoryBot.create(:building)
      get "/buildings/#{building1.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include(building1.name)
      expect(response.body).to_not include(building2.name)
    end
  end

  describe "a redirect with a legacy path starting with /libraries" do
    let(:redirect) { FactoryBot.create(:redirect) }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end

end
