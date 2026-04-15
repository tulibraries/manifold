# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SCRC Plan Your Visit Page", type: :system do
  let(:space) { FactoryBot.create(:space, slug: "scrc-reading-room") }
  let!(:category) { FactoryBot.create(:category, slug: "scrc-study") }

  before do
    allow(Space).to receive(:find_by).with(slug: "scrc-reading-room").and_return(space)
  end

  describe "page access" do
    scenario "loads the page successfully" do
      visit "/scrc/planyourvisit"

      expect(page).to have_http_status(:success)
    end

    scenario "displays the page title" do
      visit "/scrc/planyourvisit"

      expect(page).to have_content("Plan Your Visit")
    end
  end

  describe "page content" do
    scenario "displays main sections" do
      visit "/scrc/planyourvisit"

      expect(page).to have_content("Request Materials")
      expect(page).to have_content("Handling Materials")
      expect(page).to have_content("Data Collection and Use")
      expect(page).to have_content("SCRC Statement on Potentially Harmful Language")
    end
  end

  describe "category menu" do
    scenario "displays main sections" do
      visit "/scrc/planyourvisit"

      expect(page).to have_content(category.name)
      expect(page).to have_link(href: "/categories/#{category.slug}")
    end
  end

  describe "Bootstrap accordion structure" do
    scenario "has accordion elements" do
      visit "/scrc/planyourvisit"

      # Check for Bootstrap accordion elements
      expect(page).to have_css(".accordion")
      expect(page).to have_css(".accordion-item")
      expect(page).to have_css(".accordion-button")
      expect(page).to have_css(".accordion-collapse")
    end

    scenario "has proper accordion data attributes" do
      visit "/scrc/planyourvisit"

      expect(page).to have_css("[data-bs-toggle='collapse']")
      expect(page).to have_css("[data-bs-target='#requestCollapse']")
      expect(page).to have_css("[data-bs-target='#handlingCollapse']")
      expect(page).to have_css("[data-bs-target='#dataCollapse']")
    end

    scenario "accordion sections are initially collapsed" do
      visit "/scrc/planyourvisit"

      # Check that accordion sections start collapsed
      expect(page).to have_css("#requestCollapse.collapse:not(.show)")
      expect(page).to have_css("#handlingCollapse.collapse:not(.show)")
      expect(page).to have_css("#dataCollapse.collapse:not(.show)")

      # Check that buttons have collapsed class
      expect(page).to have_css(".accordion-button.collapsed")
    end
  end

  context "Bootstrap accordion JavaScript functionality", js: true do
    before do
      # Create a space for the test
      @space = FactoryBot.create(:space)
    end

    it "can expand and collapse accordion sections" do
      visit "/scrc/planyourvisit"

      # Wait for JavaScript to be loaded
      expect(page).to have_css("#planYourVisitAccordion", wait: 10)

      request_button = find("button[data-bs-target='#requestCollapse']")

      # Initially should be collapsed
      expect(page).to have_css("#requestCollapse.collapse:not(.show)")
      expect(request_button[:'aria-expanded']).to eq("false")

      request_button.click

      expect(page).to have_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("true")

      request_button.click

      expect(page).to have_no_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("false")
    end

    it "only one accordion section can be open at a time" do
      visit "/scrc/planyourvisit"

      request_button = find("button[data-bs-target='#requestCollapse']")
      handling_button = find("button[data-bs-target='#handlingCollapse']")

      # Open first section and wait for it to expand
      request_button.click
      expect(page).to have_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("true")

      # Open second section - first should close
      handling_button.click
      expect(page).to have_css("#handlingCollapse.show", wait: 5)
      expect(handling_button[:'aria-expanded']).to eq("true")
      expect(page).to have_no_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("false")
    end

    it "accordion content is accessible when expanded" do
      visit "/scrc/planyourvisit"

      request_button = find("button[data-bs-target='#requestCollapse']")

      # Initially, content should not be visible (collapsed)
      expect(page).to have_no_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("false")

      # Expand section
      request_button.click
      expect(page).to have_css("#requestCollapse.show", wait: 5)
      expect(request_button[:'aria-expanded']).to eq("true")

      # Content should now be visible
      expect(page).to have_text("You must be a registered user to request", wait: 5)
      expect(page).to have_text("Library Search and Finding Aids", wait: 5)
    end
  end

end
