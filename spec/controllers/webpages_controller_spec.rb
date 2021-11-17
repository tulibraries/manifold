# frozen_string_literal: true

require "rails_helper"

RSpec.describe WebpagesController, type: :controller do

  let(:webpage) { FactoryBot.create(:webpage) }

  describe "GET #index" do
    it "returns a success response", skip: "TBA: No views exist" do
      get :index
      expect(response).to be_successful
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #show" do
    let(:webpage) { FactoryBot.create(:webpage) }

    it "returns a success response", skip: "TBA: No views exist" do
      get :show, params: { id: webpage.to_param }
      expect(response).to be_successful
    end

    it "returns html by default success" do
      get :show, params: { id: webpage.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  describe "GET #scop" do
    let(:blog) { FactoryBot.create(:blog, title: "Scholarly Communications at Temple", slug: "scholarly-communications-at-temple") }
    let(:category) { FactoryBot.create(:category, slug: "publishing_services") }
    let(:category2) { FactoryBot.create(:category, slug: "tuscholarshare") }
    let(:webpage) { FactoryBot.create(:webpage, slug: "scop-intro", categories: [category, category2]) }

    it "returns a success response" do
      get :scop
      expect(response).to be_successful
    end

  end

  it_behaves_like "serializable"

end
