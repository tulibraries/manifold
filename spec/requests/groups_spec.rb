require 'rails_helper'

RSpec.describe "Groups", type: :request do
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building_id: building.id) }
  let(:person) { FactoryBot.create(:person, space_ids: [space.id]) }
  describe "GET /groups" do
    it "renders the group home page with all the groups" do
      group = FactoryBot.create(:group, space_ids: [space.id], person_ids: [person.id], chair_dept_head: person)
      get groups_path
      expect(response).to render_template(:index)
      expect(response.body).to include(group.name)
    end

    it "works! (now write some real specs)" do
      group = FactoryBot.create(:group, space_ids: [space.id], person_ids: [person.id], chair_dept_head: person)
      get groups_path + "/#{group.id}"
      expect(response).to render_template(:show)
      expect(response.body).to include(group.name)
    end
  end
end
