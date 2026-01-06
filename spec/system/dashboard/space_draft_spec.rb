# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboard::SpaceDrafts", type: :system do
  before(:all) do
    @account = FactoryBot.create(:account, role: "admin")
    @space = FactoryBot.create(:space)
    @models = ["space"]
  end

  after(:all) do
    Account.destroy_all
    Group.destroy_all
    Space.destroy_all
  end

  context "New Space Administrate Page" do
    scenario "Create new item " do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/spaces/new")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_description\"]")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_access_description\"]")
    end
  end

  context "Don't show draftable if draftable feature flag clear" do
    scenario "disable draftable" do
      Rails.configuration.draftable = false
      login_as(@account, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to_not have_xpath("//textarea[@id=\"space_draft_description\"]")
    end
  end

  context "Visit Space Administrate Page" do
    let(:new_description) { "Don't Panic!" }

    scenario "Change the Space Description" do
      Rails.configuration.draftable = true
      login_as(@account, scope: :account)
      visit("/admin/spaces/#{@space.id}/edit")
      expect(page).to have_xpath("//div[@id=\"space_description\"]/div[@class=\"trix-content\"]/text()[contains(., \"#{@space.description.body.to_trix_html}\")]")
      expect(page).to have_xpath("//trix-editor[@id=\"space_draft_description\"]")
      find(:xpath, "//\*[starts-with(@id, \"space_draft_description_trix_input_space\")]", visible: false).set(new_description)
      click_button("Update Space")
      expect(page).to have_content(@space.description.body.to_trix_html)
      expect(page).to_not have_content(new_description)
      visit("/admin/spaces/#{@space.id}/edit")
      check(I18n.t("manifold.admin.actions.publish"))
      click_button("Update Space")
      expect(page).to_not have_content(@space.description.body.to_trix_html)
      expect(page).to have_content(new_description)
    end
  end
end
