# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonsController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:person) { FactoryBot.create(:person) }

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
