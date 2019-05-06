require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
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

    it "returns http success" do
      get :show, params: { id: blog.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: blog.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns html by default success" do
      get :show, params: { id: blog.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end


  describe "GET #show as JSON" do
    let(:blog) { FactoryBot.create(:blog_with_sync_date) }

    it "returns valid json" do
      get :show, format: :json, params: { id: blog.id }
      Tempfile.open(["serialized_blog", ".json"]) do |serialized|
        serialized.write(response.body)
        serialized.close
        args = %W[validate -s app/schemas/blog_schema.json -d #{serialized.path}]
        expect(system("ajv", *args)).to be
      end
    end
  end
end
