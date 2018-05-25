require 'rails_helper'

RSpec.describe PersonsController, type: :controller do

  let (:person) {
    building = FactoryBot.create(:building) 

    space = FactoryBot.build(:space)
    space.building_id = building.id
    space.save!

    person = FactoryBot.build(:person)
    person.building_id = building.id
    person.space_id = space.id
    person.save!
    person
  }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: person.id }
      expect(response).to have_http_status(:ok)
    end
  end

end
