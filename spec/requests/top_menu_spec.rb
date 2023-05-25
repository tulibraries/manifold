# frozen_string_literal: true

require "rails_helper"

RSpec.feature "TopMenu", type: :request do
  describe "weighted menu navigation" do
    context "weighted entries in main menu group" do
      let(:category_1) { FactoryBot.create(:category, name: "Category 1") }
      let(:category_2) { FactoryBot.create(:category, name: "Category 2") }
      let(:webpage) { FactoryBot.create(:webpage, categories: [category_2]) }
      let(:menu_group) { FactoryBot.create(:menu_group, slug: "about-page", categories: [category_1, category_2]) }
      let(:menu_group_category_1) { FactoryBot.create(:menu_group_category, menu_group:, category: category_1) }
      let(:menu_group_category_2) { FactoryBot.create(:menu_group_category, menu_group:, category: category_2, weight: 1) }


      it "lists weighted categories in order" do
        category_2.menu_group_id = menu_group.id
        get webpage_path(webpage)
        within(".menu-items") do
          expect(page).to have_content(category_1.name)
          expect(page).to have_content(category_2.name)
          expect(category_2.name).to appear_before(category_1.name, only_text: true)
        end
      end
    end
  end
end
