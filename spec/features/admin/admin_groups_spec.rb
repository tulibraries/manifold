# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Groups", type: :feature do
  before do
    admin = FactoryBot.create(:account, admin: true)
    visit new_account_session_path

    fill_in "account_email", with: admin.email
    fill_in "account_password", with: admin.password

    click_button "commit"
  end

  context "When creating a new group with a space" do
    it "creates the group" do
      group_name = "MyGroup"
      person = FactoryBot.create(:person)
      space = FactoryBot.create(:space)

      visit admin_groups_path

      # There should not be a space link.
      expect(page).not_to have_link(group_name)
      expect(page).not_to have_title(space.name)

      click_link "New group"

      # Add a required fields
      fill_in "group_name", with: "MyGroup"
      select person.name, from: "group_chair_dept_head_ids"

      # Add space
      select space.name, from: "group_space_id"

      click_button "Create Group"

      # Expect the new group to be created with the space
      expect(page).to have_title(group_name)
      expect(page).to have_link(space.name)
    end
  end

  context "When updating a group with a space" do
    it "updates the group" do
      group = FactoryBot.create(:group)
      space = FactoryBot.create(:space)

      visit admin_groups_path + "/#{ group.friendly_id }"

      # There shouldn't be a link to the new space yet.
      expect(page).not_to have_link(space.name)

      click_link "Edit Group"

      # Add new space
      select space.name, from: "group_space_id"

      click_button "Update Group"

      # Expect to find the Room
      expect(page).to have_link(space.name)
    end
  end

  context "When deleting a space that is attached to a group" do
    it "should not error out" do
      group = FactoryBot.create(:group)


      visit admin_groups_path + "/#{ group.friendly_id }"
      expect(page).to have_link(group.space.name)

      visit admin_spaces_path
      expect(page).to have_link(group.space.name)

      click_link "Destroy"
      expect(page).not_to have_link(group.space.name)

      visit admin_groups_path + "/#{ group.friendly_id }"
      expect(page).not_to have_link(group.space.name)
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
    end
  end
end
