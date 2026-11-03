# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Turbo navigation to error pages", type: :system, js: true do
  let(:building) { FactoryBot.create(:building) }
  let(:other_building) { FactoryBot.create(:building) }

  def mark_window
    page.execute_script("window.__turboProbe = true")
  end

  def window_marked?
    page.evaluate_script("window.__turboProbe === true")
  end

  def add_link(href)
    page.execute_script(<<~JS)
      document.body.insertAdjacentHTML("beforeend",
        '<a id="probe-link" href="#{href}" style="position:fixed; top:0; left:0; z-index:2147483647;">probe link</a>')
    JS
  end

  before { visit building_path(building) }

  it "keeps successful visits as Turbo visits" do
    mark_window
    add_link(building_path(other_building))
    click_link "probe link"

    expect(page).to have_current_path(building_path(other_building))
    expect(page).to have_no_css("#probe-link")
    expect(window_marked?).to be(true)
  end

  it "does a full page load when a visit gets an error response" do
    mark_window
    add_link("/no-such-page")
    click_link "probe link"

    expect(page).to have_current_path("/no-such-page")
    expect(page).to have_no_css("#probe-link")
    expect(window_marked?).to be(false)
  end

  it "navigates back to a normal page after an error page" do
    add_link("/no-such-page")
    click_link "probe link"
    expect(page).to have_current_path("/no-such-page")
    expect(page).to have_no_css("#probe-link")

    add_link(building_path(building))
    click_link "probe link"

    expect(page).to have_current_path(building_path(building))
    expect(page).to have_content(building.name)
  end
end
