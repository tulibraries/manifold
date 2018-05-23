require 'rails_helper'

RSpec.describe SpacesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    let(:space) { FactoryBot.create(:space) }

    it "returns http success" do
      get :show, params: { id: space.id }
      expect(response).to have_http_status(:success)
    end
  end

end
