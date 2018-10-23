# frozen_string_literal: true

require "rails_helper"

RSpec.describe PersonsController, type: :controller do

  include Devise::Test::ControllerHelpers

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:chair_person) { FactoryBot.create(:person, spaces: [space]) }
  let(:group) { FactoryBot.create(:group, spaces: [space], chair_dept_head: chair_person) }
  let(:person) { person = FactoryBot.create(:person, groups: [group], spaces: [space]) }

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
