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

    it "returns html by default" do
      get :index
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end

    describe "set_filters" do

      describe "Department Filter" do
        let(:person2) { FactoryBot.create(:person) }
        let(:group) { FactoryBot.create(:group, persons: [person2]) }
        it "filters department present" do
          get :index, format: :json, params: { department: group }
          expect(assigns(:persons_list)).to include(person2)
          expect(assigns(:persons_list)).not_to include(person)
        end
      end

      describe "Specialists Filter" do
        before(:all) do
          @specialty = FactoryBot.create(:subject)
          @person2 = FactoryBot.create(:person, specialties: [@specialty])
        end

        it "filters specialist" do
          get :index, format: :json, params: { specialists: @specialty }
          expect(assigns(:persons_list)).to include(@person2)
          expect(assigns(:persons_list)).not_to include(person)
        end
      end

      describe "Search Filter" do
        let(:person2) { FactoryBot.create(:person) }
        it "filter by search term" do
          get :index, format: :json, params: { search: person2.name }
          expect(assigns(:persons_list)).to include(person2)
          expect(assigns(:persons_list)).not_to include(person)
        end
      end
    end

  end

  describe "GET #show" do
    it "returns http success" do
      get :show, params: { id: person.id }
      expect(response).to have_http_status(:ok)
    end

    it "returns html by default success" do
      get :show, params: { id: person.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns html by default success" do
      get :show, params: { id: person.id }, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end

  end

  it_behaves_like "serializable"

end
