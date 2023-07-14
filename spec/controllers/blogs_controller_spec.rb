# frozen_string_literal: true

require "rails_helper"

RSpec.describe BlogsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:found)
    end

    it "returns html by default" do
      get :index
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:blog) { FactoryBot.create(:blog) }

    it "returns html by default success" do
      get :show, params: { id: blog.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end


  it_behaves_like "serializable"

end
