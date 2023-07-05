# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/hsl", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    @category = FactoryBot.create(:category)
    @study_room = FactoryBot.create(:external_link)
    @resource_links = [FactoryBot.create(:category)]
    @research_links = [FactoryBot.create(:category)]
    @visit_links = [FactoryBot.create(:category)]
    @event_links = [FactoryBot.create(:event, end_time: Date.current, tags: "health sciences")]
    @remote_learning = FactoryBot.create(:webpage)
    render
    expect(rendered).to match /id="hsl_ginsburg_link_button"/
    expect(rendered).to match /id="hsl_podiatry_link_button"/
    expect(rendered).to match /id="hsl_study_room_button"/
    expect(rendered).to match /id="hsl_appointment_link_button"/
    expect(rendered).to match /id="hsl_email_link_button"/
    expect(rendered).to match /id="hsl_journal_finder_button"/
    expect(rendered).to match /id="hsl_support_button"/
    expect(rendered).to match /id="hsl_visit_header"/
    expect(rendered).to match /id="hsl_resources_header"/
    expect(rendered).to match /id="hsl_research_header"/
    expect(rendered).to match /id="hsl_events_header"/
    expect(rendered).to match /id="hsl_events_view_all"/
    expect(rendered).to match /id="hsl_resources_view_all"/
  end
end
