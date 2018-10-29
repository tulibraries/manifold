# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServicesController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }
  let(:group) { FactoryBot.create(:group, spaces: [space], chair_dept_heads: [chair_person]) }
  let(:service) { FactoryBot.create(:service, related_spaces: [space], related_groups: [group]) }

  describe "GET #index" do
    it "renders index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "assigns service" do
      get :index
      expect(assigns(:services)).to eq([service])
    end
  end

  describe "GET #show" do
    it "renders show template" do
      get :show, params: { id: service.id }
      expect(response).to render_template("show")
    end
  end
end
