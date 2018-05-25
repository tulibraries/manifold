require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let (:group) {
      building = FactoryBot.create(:building)

      space = FactoryBot.build(:space)
      space.building_id = building.id
      space.save!

      person = FactoryBot.build(:person)
      person.building_id = building.id
      person.space_id = space.id
      person.save!

      group = FactoryBot.build(:group)
      group.building_id = building.id
      group.space_id = space.id
      group.person_id = person.id
      group.save!
      group
  }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: group.id }
      expect(response).to have_http_status(:success)
    end
  end

end
