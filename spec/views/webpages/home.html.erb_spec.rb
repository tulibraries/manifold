# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/home", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    highlight = FactoryBot.create(:highlight, title: "Digcol with Image", promoted: true, promote_to_dig_col: true)
    @highlights = [highlight]
    @digcols = [highlight]
    render
    expect(rendered).to match /id="ambler"/
    expect(rendered).to match /id="law"/
    expect(rendered).to match /id="scrc"/
    expect(rendered).to match /id="blockson"/
    expect(rendered).to match /id="lcdss"/
    expect(rendered).to match /id="hsl"/
    expect(rendered).to match /id="research-help"/
    expect(rendered).to match /id="study-space"/
    expect(rendered).to match /id="printing-computing"/
    expect(rendered).to match /id="online-resources"/
    expect(rendered).to match /id="books-media"/
    expect(rendered).to match /id="articles"/
    expect(rendered).to match /id="databases"/
    expect(rendered).to match /id="research-guides"/
    expect(rendered).to match /id="journal-finder"/
    expect(rendered).to match /id="collections-search"/
    expect(rendered).to match /id="news-events"/
    expect(rendered).to match /id="charles-library"/
    expect(rendered).to match /id="scop"/
  end

  it "uses the shared carousel controller for each homepage carousel" do
    @webpage = FactoryBot.create(:webpage)
    highlight = FactoryBot.create(:highlight, :with_image, promote_to_dig_col: true)
    @highlights = []
    @digcols = [highlight]

    render

    expect(rendered).to have_css(".home-events-row[data-controller='carousel']")
    expect(rendered).to have_css(".home-news-row[data-controller='carousel']")
    expect(rendered).to have_css(".home-digcol-row[data-controller='carousel']")
  end

  describe "the featured events carousel" do
    before(:each) do
      @webpage = FactoryBot.create(:webpage)
      @highlights = []
      @digcols = []
    end

    it "overlays the card date and lists the location above the title" do
      @featured_events = [FactoryBot.create(:event,
                                            title: "Fall Open House",
                                            location_name: "Charles Library",
                                            location_space: "Atrium")]

      render

      expect(rendered).to have_css(".library-event .event-image .event-date",
                                   text: @featured_events.first.card_date)
      expect(rendered).to have_css(".library-event .event-card-location", text: "Charles Library, Atrium")
      expect(rendered).to have_css(".library-event .event-title", text: "Fall Open House")
    end

    it "renders a highlighted exhibition as a card alongside the events" do
      exhibition = FactoryBot.create(:exhibition,
                                     title: "Highlighted Exhibition",
                                     start_date: Date.current,
                                     end_date: Date.current + 1,
                                     highlighted: true)
      event = FactoryBot.create(:event, title: "Fall Open House", featured: true)
      @featured_events = [exhibition, event]

      render

      cards = Capybara.string(rendered).all("#newsCarouselItems .carousel-item")
      expect(cards.first).to have_css(".event-title", text: "Highlighted Exhibition")
      expect(cards.first).to have_css(".event-date", text: exhibition.card_date)
      expect(cards.first[:class]).to include("active")
      expect(cards.last).to have_css(".event-title", text: "Fall Open House")
    end

    it "omits the location when the event is located nowhere" do
      @featured_events = [FactoryBot.create(:event, location_name: nil, location_space: nil, event_url: nil)]

      render

      expect(rendered).to have_css(".library-event .event-date")
      expect(rendered).to have_no_css(".library-event .event-card-location")
    end
  end
end
