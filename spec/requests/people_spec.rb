# frozen_string_literal: true

require "rails_helper"

RSpec.describe "People", type: :request do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building_id: building.id) }
  describe "GET /people" do
    it "renders the person home page with all the people" do
      person = FactoryBot.create(:person, space_ids: [space.id])
      get people_path
      expect(response).to render_template(:index)
      expect(response.body).to include(person.last_name)
    end

    it "works! (now write some real specs)" do
      person = FactoryBot.create(:person, space_ids: [space.id])
      get people_path + "/#{person.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include(person.name)
    end
  end
end
