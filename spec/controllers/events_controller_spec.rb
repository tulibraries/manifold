# frozen_string_literal: true

require "rails_helper"
require "tempfile"

RSpec.describe EventsController, type: :controller do
  render_views

  let(:building) { FactoryBot.create(:building) }
  let(:space) { FactoryBot.create(:space, building:) }
  let(:person) { FactoryBot.build(:person, buildings: [building]) }

  let(:past_event) {
    FactoryBot.create(:event, building:, space:, person:)
  }
  let(:current_event) {
    FactoryBot.create(:event, start_time: DateTime.tomorrow, end_time: DateTime.tomorrow + 1)
  }
  let(:current_workshop) {
    FactoryBot.create(:event, start_time: DateTime.tomorrow, end_time: DateTime.tomorrow + 1, event_type: "workshop")
  }
  let(:suppressed_event) {
    FactoryBot.create(:event, suppress: true, start_time: DateTime.tomorrow, end_time: DateTime.tomorrow + 1, title: "Suppressed Event")
  }
  let(:future_event) {
    FactoryBot.create(:event, start_time: Date.current, end_time: Date.current + 1, tags: "digital scholarship, health sciences", title: "DSS Event")
  }
  let(:past_workshop) {
    FactoryBot.create(:event, start_time: DateTime.yesterday, end_time: DateTime.yesterday, event_type: "workshop")
  }
  let(:events) {
    [past_event, current_event, current_workshop, suppressed_event, future_event, past_workshop]
  }

  before(:each) do
    @events = events
  end

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

    it "returns events & workshops by default" do
      get :index
      expect(response.body).to include current_event.title
      expect(response.body).to include current_workshop.title
    end

    it "does not return suppressed events" do
      get :index
      expect(response.body).not_to include suppressed_event.title
    end

    it "does not return past events or workshops" do
      get :index
      expect(response.body).to_not include past_event.title
      expect(response.body).to_not include past_workshop.title
    end

    it "returns date matched results" do
      get :index, params: { date: current_event.start_time.strftime("%Y-%m-%d") }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include past_event.title
    end

    it "return events only when specified" do
      get :index, params: { type: "events-only" }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include current_workshop.title
    end
  end

  describe "GET #past_events" do
    it "returns past events" do
      get :past_events
      expect(response.body).to include past_event.title
      expect(response.body).to_not include current_event.title
    end

    it "return events only when specified" do
      get :past_events, params: { type: "events-only" }
      expect(response.body).to include past_event.title
      expect(response.body).to_not include past_workshop.title
    end

    it "returns past date matched results" do
      get :past_events, params: { date: past_event.start_time.strftime("%Y-%m-%d") }
      expect(response.body).to include past_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "POST #search" do
    it "returns search results" do
      post :search, params: { search: current_event.title }
      expect(response.body).to include current_event.title
      expect(response.body).to_not include past_event.title
    end

    it "returns tag-based search results" do
      post :search, params: { search: "digital scholarship" }
      expect(response.body).to include future_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "POST #past_search" do
    it "returns past search results" do
      post :past_search, params: { search: past_event.title }
      expect(response.body).to include past_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "GET #workshops" do
    it "returns current workshops only" do
      get :workshops
      expect(response.body).to include current_workshop.title
      expect(response.body).to_not include past_workshop.title
      expect(response.body).to_not include current_event.title
      expect(response.body).to_not include past_event.title
    end
  end

  describe "GET #past_workshops" do
    it "returns past workshops" do
      get :past_workshops
      expect(response.body).to include past_workshop.title
      expect(response.body).to_not include current_workshop.title
      expect(response.body).to_not include current_event.title
      expect(response.body).to_not include past_event.title
    end
  end

  describe "GET #dss_events" do
    it "returns dss events" do
      get :dss_events
      expect(response.body).to include future_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "GET #hsl_events" do
    it "returns hsl events" do
      get :hsl_events
      expect(response.body).to include future_event.title
      expect(response.body).to_not include current_event.title
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: past_event.id }
      expect(response).to render_template("show")
    end

    it "returns html by default" do
      get :show, params: { id: past_event.id }
      expect(response.header["Content-Type"]).to include "html"
    end

    it "returns json when requested" do
      get :show, format: :json, params: { id: past_event.id }
      expect(response.header["Content-Type"]).to include "json"
    end
  end

  it_behaves_like "serializable"

end
