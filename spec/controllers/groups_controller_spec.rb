# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroupsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:group) { FactoryBot.create(:group) }

  describe "GET #index" do
    it "redirects to home page" do
      get :index
      expect(response).to redirect_to "/"
    end
  end

  describe "GET #show" do
    it "redirects to home page" do
      get :show, params: { id: group.id }
      expect(response).to redirect_to "/"
    end
  end
end
