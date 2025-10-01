# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/tudsc", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    @event_links = [FactoryBot.create(:event, end_time: Time.zone.now, tags: "digital scholarship")]
    @blog = FactoryBot.create(:blog)
    render
    expect(rendered).to match /id="lcdss_makerspace_button"/
    expect(rendered).to match /id="lcdss_vr_studio_button"/
    expect(rendered).to match /id="lcdss_newsletter_button"/
    expect(rendered).to match /id="lcdss_staff_link_button"/
    expect(rendered).to match /id="lcdss_visit_header"/
    expect(rendered).to match /id="lcdss_research_header"/
    expect(rendered).to match /id="lcdss_events_header"/
    expect(rendered).to match /id="lcdss_blog_header"/
    expect(rendered).to match /id="lcdss_blog_view_all"/
  end
end
