# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/scop", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    @pub_services = FactoryBot.create(:category)
    @scholar_share = FactoryBot.create(:category)
    @event_links = [FactoryBot.create(:event, end_time: Time.zone.now, tags: "SCOP")]
    @blog = FactoryBot.create(:blog)
    render
    expect(rendered).to match /id="scop_scholar_share_button"/
    expect(rendered).to match /id="scop_nb_press_button"/
    expect(rendered).to match /id="scop_open_journals_button"/
    expect(rendered).to match /id="scop_contact_button"/
    expect(rendered).to match /id="scop_pub_services_header"/
    expect(rendered).to match /id="scop_scholar_share_header"/
    expect(rendered).to match /id="scop_events_header"/
    expect(rendered).to match /id="scop_events_view_all"/
    expect(rendered).to match /id="scop_blog_header"/
    expect(rendered).to match /id="scop_blog_view_all"/
  end
end
