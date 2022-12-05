# frozen_string_literal: true

require "rails_helper"
require "tempfile"

RSpec.describe EventsController, type: :controller do
  render_views

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building: building) }
  let(:person) { FactoryBot.build(:person, buildings: [building]) }

  let(:event) {
    FactoryBot.create(:event, building: building, space: space, person: person)
  }
  let(:current_event) {
    FactoryBot.create(:event, start_time: DateTime.tomorrow, end_time: DateTime.tomorrow + 1, event_type: "workshop")
  }
  let(:future_event) {
    FactoryBot.create(:event, start_time: Date.current, end_time: Date.current + 1, tags: "digital scholarship", title: "DSS Event")
  }
  let(:past_workshop) {
    FactoryBot.create(:event, start_time: DateTime.yesterday, end_time: DateTime.yesterday, event_type: "workshop")
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "returns html by default" do
      get :index
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :index, format: :json
      expect(response.header["Content-Type"]).to include "json"
    end

    it "returns future events" do
      @all_current_events = [current_event]
      get :index
      expect(response.body).to include current_event.title
    end

    it "does not return past events" do
      @all_current_events = [current_event]
      @all_past_events = [event]
      get :index
      expect(response.body).to_not include event.title
    end

    it "returns past events" do
      @all_past_events = [event]
      get :past
      expect(response.body).to include event.title
      expect(response.body).to_not include current_event.title
    end

    it "returns search results" do
      post :search, params: { search: current_event.title }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include event.title
    end

    it "returns tag-based search results" do
      @all_current_events = [current_event, future_event]
      post :search, params: { search: "digital scholarship" }
      expect(response.body).to include future_event.title
      expect(response.body).to_not include current_event.title
    end

    it "returns past search results" do
      post :past_search, params: { search: event.title }
      expect(response.body).to include event.title
      expect(response.body).to_not include current_event.title
    end

    it "returns date matched results" do
      get :index, params: { date: current_event.start_time.strftime("%Y-%m-%d") }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include event.title
    end

    it "returns past date matched results" do
      get :past, params: { date: event.start_time.strftime("%Y-%m-%d") }
      expect(response.body).to include event.title
      expect(response.body).to_not include current_event.title
    end

    it "returns current workshops" do
      @all_current_events = [current_event]
      @all_past_events = [event]
      get :index, params: { type: "workshop" }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include event.title
    end

    it "returns past workshops" do
      @all_past_events = [past_workshop]
      get :past, params: { type: "workshop" }
      expect(response.body).to include past_workshop.title
    end

    it "returns dss events" do
      @all_current_events = [current_event, future_event]
      get :dss_events
      expect(response.body).to include future_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: event.id }
      expect(response).to render_template("show")
    end

    it "returns html by default" do
      get :show, params: { id: event.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :show, format: :json, params: { id: event.id }
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
