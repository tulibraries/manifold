# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/blockson", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    @category = FactoryBot.create(:category)
    @event = FactoryBot.create(:event)
    @tours = [@category]
    @events_links = [@event]
    render
    expect(rendered).to match /id="blockson_digitized_materials_button"/
    expect(rendered).to match /id="blockson_hours_and_info_button"/
    expect(rendered).to match /id="blockson_visit_header"/
    expect(rendered).to match /id="blockson_tours_header"/
    expect(rendered).to match /id="blockson_events_header"/
    expect(rendered).to match /id="blockson_events_view_all"/
    expect(rendered).to match /id="blockson_research_header"/
  end
end
