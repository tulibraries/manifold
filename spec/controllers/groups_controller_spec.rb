# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:group) { FactoryBot.create(:group) }

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
