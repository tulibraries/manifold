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

    it "includes promoted current exhibitions in the paginated listing" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Current Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     promoted_to_events: true)

      get :index

      expect(response.body).to include exhibition.title
      expect(response.body).to include(exhibition_path(exhibition))
    end

    it "places promoted exhibitions before events and keeps the combined page size" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "First Current Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     promoted_to_events: true)
      13.times do |index|
        FactoryBot.create(:event,
                           title: "Paginated Current Event #{index}",
                           start_time: Date.current + 30 + index,
                           end_time: Date.current + 31 + index)
      end

      get :index

      listings = assigns(:events_list).to_a
      expect(listings.length).to eq(12)
      expect(listings.first.source).to eq(exhibition)
    end

    it "does not skip or duplicate listings across pages" do
      20.times do |index|
        FactoryBot.create(:event,
                           title: "Ordered Current Event #{index}",
                           start_time: Date.current + 40 + index,
                           end_time: Date.current + 41 + index)
      end

      get :index
      first_page_ids = assigns(:events_list).map(&:listing_id)

      get :index, params: { page: 2 }
      second_page_ids = assigns(:events_list).map(&:listing_id)

      expected_ids = EventListing.feed.current.exhibitions_first.limit(24).pluck(:listing_id)
      expect(first_page_ids + second_page_ids).to eq(expected_ids)
    end

    it "does not include unpromoted exhibitions" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Unpromoted Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     promoted_to_events: false)

      get :index

      expect(response.body).not_to include(exhibition.title)
    end

    it "uses three featured events when no exhibition is highlighted" do
      featured_events = 3.times.map do |index|
        FactoryBot.create(:event,
                           title: "Unhighlighted Featured Event #{index}",
                           featured: true,
                           start_time: Date.current + index + 1,
                           end_time: Date.current + index + 2)
      end

      get :index

      expect(assigns(:featured_events)).to eq(featured_events)
    end

    it "includes exhibitions that span a selected date" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Date-Spanning Exhibition",
                                     start_date: Date.current - 1,
                                     end_date: Date.current + 1,
                                     promoted_to_events: true)

      get :index, params: { date: Date.current.iso8601 }

      expect(response.body).to include(exhibition.title)
    end

    it "excludes exhibitions from the events-only filter" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Excluded Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     promoted_to_events: true)

      get :index, params: { type: "events-only" }

      expect(response.body).not_to include(exhibition.title)
    end

    it "uses one exhibition and two events in the featured area" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Highlighted Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     highlighted: true)
      featured_events = 3.times.map do |index|
        FactoryBot.create(:event,
                           title: "Featured Event #{index}",
                           featured: true,
                           start_time: Date.current + index + 1,
                           end_time: Date.current + index + 2)
      end

      get :index

      expect(assigns(:featured_events)).to eq([exhibition, *featured_events.first(2)])
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

    it "includes promoted past exhibitions in the paginated listing" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Past Exhibition",
                                     start_date: Date.current - 2,
                                     end_date: Date.current - 1,
                                     promoted_to_events: true)

      get :past_events

      expect(response.body).to include exhibition.title
    end

    it "orders the combined past listing by end date" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Earlier Past Exhibition",
                                     start_date: Date.current - 4,
                                     end_date: Date.current - 3,
                                     promoted_to_events: true)
      event = FactoryBot.create(:event,
                                title: "Later Past Event",
                                start_time: Date.current - 2,
                                end_time: Date.current - 1)

      get :past_events

      titles = assigns(:events_list).map(&:title)
      expect(titles.index(event.title)).to be < titles.index(exhibition.title)
    end

    it "does not include unpromoted past exhibitions" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Unpromoted Past Exhibition",
                                     start_date: Date.current - 2,
                                     end_date: Date.current - 1,
                                     promoted_to_events: false)

      get :past_events

      expect(response.body).not_to include(exhibition.title)
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

    it "returns promoted current exhibitions" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Searched Current Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     promoted_to_events: true)

      post :search, params: { search: exhibition.title }

      expect(response.body).to include exhibition.title
    end

    it "returns event tag matches" do
      tagged_event = FactoryBot.create(:event,
                                        title: "Tagged Current Event",
                                        tags: "unified listing",
                                        start_time: Date.current + 1,
                                        end_time: Date.current + 2)

      post :search, params: { search: "unified listing" }

      expect(response.body).to include(tagged_event.title)
    end
  end

  describe "POST #past_search" do
    it "returns past search results" do
      post :past_search, params: { search: past_event.title }
      expect(response.body).to include past_event.title
      expect(response.body).to_not include current_event.title
    end

    it "returns promoted past exhibitions" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Searched Past Exhibition",
                                     start_date: Date.current - 2,
                                     end_date: Date.current - 1,
                                     promoted_to_events: true)

      post :past_search, params: { search: exhibition.title }

      expect(response.body).to include exhibition.title
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

    it "treats a suppressed event as not found" do
      expect { get :show, params: { id: suppressed_event.id } }
        .to raise_error(ActionController::RoutingError)
    end
  end

  it_behaves_like "serializable"

end
