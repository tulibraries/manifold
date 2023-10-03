# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesController, type: :controller do

  let(:category) { FactoryBot.create(:category) }

  describe "GET #index" do

    it "returns html when requested" do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do

    it "returns http success" do
      get :show, params: { id: category.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
