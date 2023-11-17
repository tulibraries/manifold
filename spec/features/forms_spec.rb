# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Forms", type: :feature do
  
  describe "page groupings" do
    scenario "admin services appears last" do
      first = FactoryBot.create(:form_info, grouping: "Not Grouped")
      last = FactoryBot.create(:form_info, grouping: "Administrative Services")
      visit(forms_path)
      expect(page).to have_content(first.grouping)
      expect(page).to have_content(last.grouping)
      expect(first.grouping).to appear_before(last.grouping, only_text: true)
    end
  end

end
