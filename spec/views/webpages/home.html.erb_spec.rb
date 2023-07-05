# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/home", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "has required ids for analytics tracking" do
    @webpage = FactoryBot.create(:webpage)
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
end
