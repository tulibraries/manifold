# frozen_string_literal: true

require "rails_helper"

RSpec.describe "application/_menu-items.html.erb", type: :view do
  let(:menu_group) { FactoryBot.create(:menu_group) }
  let(:custom_category) { FactoryBot.create(:category, custom_url: "https://example.com/custom") }
  let(:tabbed_category) { FactoryBot.create(:category, name: "Library Services") }
  let(:custom_item) { FactoryBot.create(:menu_group_category, menu_group:, category: custom_category, weight: 1) }
  let(:tabbed_item) { FactoryBot.create(:menu_group_category, menu_group:, category: tabbed_category, weight: 2) }

  before do
    allow(view).to receive(:get_items) do |category|
      if category == custom_category
        ""
      elsif category == tabbed_category
        "<ul><li><a href=\"/library-hours\">Library Hours</a></li></ul>"
      else
        ""
      end
    end
  end

  it "links directly to the category custom URL when no items are available" do
    render partial: "application/menu-items", locals: { menu: "visit", items: [custom_item] }

    expect(rendered).to include(%(href="#{custom_category.custom_url}"))
    expect(rendered).not_to include(%(href="#visit-#{custom_category.name.parameterize}-items"))
  end

  it "renders a tabbed panel when category has items" do
    render partial: "application/menu-items", locals: { menu: "visit", items: [tabbed_item] }

    anchor = "#visit-#{tabbed_category.name.parameterize}-items"
    expect(rendered).to include(%(href="#{anchor}"))
    expect(rendered).to include("<ul><li><a href=\"/library-hours\">Library Hours</a></li></ul>")
  end

  it "handles categories with and without items together" do
    render partial: "application/menu-items", locals: { menu: "visit", items: [custom_item, tabbed_item] }

    expect(rendered).to include(%(href="#{custom_category.custom_url}"))
    expect(rendered).to include(%(href="#visit-#{tabbed_category.name.parameterize}-items"))
  end
end
