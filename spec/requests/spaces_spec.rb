# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Spaces", type: :request do
  let(:building) { FactoryBot.create(:building) }
  describe "GET /spaces" do
    it "renders the space home page with all the spaces" do
      space = FactoryBot.create(:space, building_id: building.id)
      get spaces_path
      expect(response).to render_template(:index)
      expect(response.body).to include(space.name)
    end

    it "works! (now write some real specs)" do
      space = FactoryBot.create(:space, building_id: building.id)
      get spaces_path + "/#{space.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include(space.name)
    end
  end
end
