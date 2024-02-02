# frozen_string_literal: true

require "rails_helper"

RSpec.feature "TopMenu", type: :request do
  describe "weighted menu navigation" do
    context "weighted entries in main menu group" do
      # menu_group_categories have cateogries and are assigned to menu_groups (which are the main nav menu items in the site)
      let(:category_1) { FactoryBot.create(:category, name: "Alphaville") }
      let(:category_2) { FactoryBot.create(:category, name: "Zetatopolis") }
      let(:menu_group) { FactoryBot.create(:menu_group, slug: "about-page", categories: [category_1, category_2]) }
      let(:menu_group_category_1) { FactoryBot.create(:menu_group_category, menu_group:, category: category_1, weight: 2) }
      let(:menu_group_category_2) { FactoryBot.create(:menu_group_category, menu_group:, category: category_2, weight: 1) }

      it "lists weighted categories in order" do
        menu_group_category_1.menu_group_id = menu_group.id
        menu_group_category_2.menu_group_id = menu_group.id
        get root_path
        expect(response.body).to match(category_1.name)
        expect(response.body).to match(category_2.name)
        expect(response.body.index(category_2.name)).to be < response.body.index(category_1.name)
      end
    end
  end
end
