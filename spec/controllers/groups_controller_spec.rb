require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  #let (:building) { FactoryBot.create(:building) }
  #let (:space) { FactoryBot.create(:space) }
  #let (:person) { FactoryBot.build(:person) }
  #let (:group) { group = FactoryBot.create(:group) }
  let (:group) { FactoryBot.create(:grouop) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      group = FactoryBot.create(:group)
      get :show, params: { id: group.id }
      expect(response).to have_http_status(:ok)
    end
  end

end
