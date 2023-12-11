# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Groups", type: :system do
  before do
    login_as(FactoryBot.create(:administrator))
  end

  context "When creating a new group with a space" do
    it "adds a space on creation" do
      person = FactoryBot.create(:person)
      space = FactoryBot.create(:space, name: "first space")
      group_name = "MyGroup"

      visit admin_groups_path
      click_link "New group"

      # Add a required fields
      fill_in "group_name", with: group_name
      select person.name, from: "group_chair_dept_head_ids"

      select space.name, from: "group_space_id"
      click_button "Create Group"

      # Expect the new group to be created with the space
      expect(page).to have_title(group_name)
      expect(page).to have_link(space.name)
    end
  end

  context "When updating a group without a space" do
    it "adds a space to the group" do
      group = FactoryBot.create(:group, name: "second group")
      space = FactoryBot.create(:space, name: "second space")

      visit admin_groups_path + "/#{ group.friendly_id }/edit"
      expect(page).to have_text(group.name)

      select space.name, from: "group_space_id"

      click_button "Update Group"
      expect(page).to have_link(space.name)
    end
  end

  context "When there is a list of spaces" do
    it "should order the list in ASC order by name" do
      FactoryBot.create(:space, name: "zoo")
      FactoryBot.create(:space, name: "foo")
      FactoryBot.create(:space, name: "A")
      FactoryBot.create(:space, name: "bar")

      visit admin_groups_path
      click_link "New group"
      select_field = find("#group_space_id")

      options = select_field.all("option").map(&:text)
      expect(options).to eq(options.sort)

      expect(options.first).to be_blank
    end
  end

end
