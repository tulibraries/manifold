# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Spaces", type: :request do
  let(:building) { FactoryBot.create(:building) }
  describe "GET /spaces" do
    it "renders the space home page with all the spaces" do
      skip "Are these necessary?"
      space = FactoryBot.create(:space, building_id: building.id)
      get spaces_path
      expect(response).to render_template(:index)
      expect(response.body).to include(space.name)
    end

    it "works! (now write some real specs)" do
      skip "Are these necessary?"
      space = FactoryBot.create(:space, building_id: building.id)
      get spaces_path + "/#{space.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include(space.name)
    end
  end

  describe "a redirect with a legacy path starting with /space" do
    let(:redirect) { FactoryBot.create(:space_redirect) }
    it "redirects to the expected redirect path" do
      get url_for(redirect.legacy_path)
      expect(response).to redirect_to(redirect.path)
    end
  end
end
