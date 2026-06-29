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

    context "filtering by department" do
      let(:group) { FactoryBot.create(:group) }

      it "filters via desktop department param" do
        get :index, params: { department: group.slug }
        expect(assigns(:filtered_persons)).to include(*group.persons)
      end

      it "filters via mobile m_department param" do
        get :index, params: { m_department: group.slug }
        expect(assigns(:filtered_persons)).to include(*group.persons)
      end
    end

    context "filtering by specialty" do
      let(:subject) { FactoryBot.create(:subject) }
      let!(:person_with_subject) { FactoryBot.create(:person, subjects: [subject]) }

      it "filters via desktop specialty param" do
        get :index, params: { specialty: subject.name }
        expect(assigns(:filtered_persons)).to include(person_with_subject)
      end

      it "filters via mobile m_subject param" do
        get :index, params: { m_subject: subject.name }
        expect(assigns(:filtered_persons)).to include(person_with_subject)
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
