# frozen_string_literal: true

require "rails_helper"

RSpec.describe "application/_header_navbar.html.erb", type: :view do
  before do
    assign(:alert, alerts)
    assign(:header_search, nil)
    assign(:mobile_search, nil)

    allow(view).to receive(:action_name).and_return("home")

    stub_template "application/_todays_date.html.erb" => ""
    stub_template "application/_main-menu.html.erb" => ""
    stub_template "application/_mobile-nav.html.erb" => ""
  end

  context "when the alert has custom link text" do
    let(:alerts) do
      [FactoryBot.build(:alert, scroll_text: "Library Search notice.", link: "https://librarysearch.temple.edu", link_text: "Read the outage notice")]
    end

    it "renders the custom link text" do
      render partial: "application/header_navbar"

      expect(rendered).to include("Library Search notice.")
      expect(rendered).to include("Read the outage notice")
      expect(rendered).to include(%(href="https://librarysearch.temple.edu"))
      expect(rendered).not_to include(I18n.t("manifold.default.application.header_navbar.scroll_text"))
    end
  end

  context "when the alert link text is blank" do
    let(:alerts) do
      [FactoryBot.build(:alert, scroll_text: "Library Search notice.", link: "https://librarysearch.temple.edu", link_text: "")]
    end

    it "renders the fallback link text" do
      render partial: "application/header_navbar"

      expect(rendered).to include("Library Search notice.")
      expect(rendered).to include(I18n.t("manifold.default.application.header_navbar.scroll_text"))
      expect(rendered).to include(%(href="https://librarysearch.temple.edu"))
    end
  end
end
