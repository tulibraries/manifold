# frozen_string_literal: true

require "rails_helper"

RSpec.describe "webpages/show", type: :view do

  before(:each) do
    view.lookup_context.prefixes << "application"
  end

  it "displays an external link" do
    @webpage = FactoryBot.create(:webpage, :with_external_link, slug: "annual-report")
    render
    expect(rendered).to match /"#{@webpage.external_link.link}/
  end

end
