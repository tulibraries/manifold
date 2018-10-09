# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventsController, type: :controller do

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, spaces: [space]) }

  let(:event) {
    FactoryBot.create(:event, building: building, space: space, person: person)
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns service" do
      get :index
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: event.to_param }
      expect(response).to render_template("show")
    end
  end

end
