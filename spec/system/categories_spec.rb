# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Categories", type: :system do

  before(:all) do
    @explore_charles = FactoryBot.create(:category, slug: "explore-charles")
  end

  describe "explore charles category" do
    scenario "first slide maches alt text set in config" do
      visit category_path(@explore_charles)
      within "#slide-image" do
        find(".carousel-item", match: :first).first("img") do |img|
          expect(img["alt"]).to match I18n.t("manifold.categories.charles_slide_alt_texts")[0]
        end
      end
    end
  end

end
