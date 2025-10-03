# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/scrc", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
    @intro = FactoryBot.create(:snippet)
    @visit_links = [FactoryBot.create(:category)]
    @collection_links = [FactoryBot.create(:category)]
    render
    expect(rendered).to match /id="scrc_finding_aids_button"/
    expect(rendered).to match /id="scrc_plan_visit_button"/
    expect(rendered).to match /id="scrc_materials_button"/
    expect(rendered).to match /id="scrc_search_button"/
    expect(rendered).to match /id="scrc_copy_request_button"/
    expect(rendered).to match /id="scrc_av_request_button"/
    expect(rendered).to match /id="scrc_instruction_button"/
    expect(rendered).to match /id="scrc_researcher_button"/
    expect(rendered).to match /id="scrc_emphases_header"/
  end
end
