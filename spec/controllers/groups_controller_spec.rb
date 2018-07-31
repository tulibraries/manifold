require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  #let (:person) { FactoryBot.build(:person) }
  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:group) { FactoryBot.create(:group, spaces: [space]) }

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: group.id }
      expect(response).to have_http_status(:ok)
    end
  end

end
