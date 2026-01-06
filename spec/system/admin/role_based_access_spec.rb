# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Role-based Admin Access", type: :system do
  let(:admin) { FactoryBot.create(:account, role: "admin") }
  let(:form_admin_group) { FactoryBot.create(:admin_group, managed_entities: ["FormSubmission"]) }
  let(:form_admin) { FactoryBot.create(:account, role: "regular", admin_group: form_admin_group) }
  let(:other_admin_group) { FactoryBot.create(:admin_group, managed_entities: ["Building", "Person"]) }
  let(:other_admin) { FactoryBot.create(:account, role: "regular", admin_group: other_admin_group) }
  let(:regular_user) { FactoryBot.create(:account, role: "regular") }

  after do
    Account.destroy_all
    AdminGroup.destroy_all
  end

  context "Full administrator" do
    it "can access all admin pages" do
      login_as(admin, scope: :account)
      visit admin_root_path

      expect(page).to have_link("Form Submissions")
      expect(page).to have_link("Accounts")
      expect(page).to have_link("Admin Groups")
      expect(page).to have_link("Buildings")
    end

    it "can access form submissions" do
      login_as(admin, scope: :account)
      visit admin_form_submissions_path

      expect(page).to have_content("Form Submissions")
      expect(page.status_code).to eq(200)
    end
  end

  context "Form submissions admin group member" do
    it "can access form submissions index" do
      login_as(form_admin, scope: :account)
      visit admin_form_submissions_path

      expect(page).to have_content("Form Submissions")
      expect(page.status_code).to eq(200)
    end

    it "gets redirected from admin root to form submissions" do
      login_as(form_admin, scope: :account)
      visit admin_root_path

      expect(current_path).to eq("/admin/form_submissions")
    end

    it "cannot access buildings admin" do
      login_as(form_admin, scope: :account)
      visit admin_buildings_path

      expect(page).to have_content("You are not authorized to access this page")
      expect(current_path).to eq("/admin/form_submissions")
    end

    it "has restricted navigation (only sees Form Submissions)" do
      login_as(form_admin, scope: :account)
      visit admin_form_submissions_path

      expect(page).to have_link("Form Submissions")
      expect(page).to_not have_link("Admin Groups")
      expect(page).to_not have_link("Accounts")
      expect(page).to_not have_link("Buildings")
      expect(page).to_not have_link("Spaces")
      expect(page).to_not have_link("Events")
    end
  end

  context "Other admin group member (not Form Submission)" do
    it "can access all admin areas like before" do
      login_as(other_admin, scope: :account)
      visit admin_buildings_path

      expect(page).to have_content("Buildings")
      expect(page.status_code).to eq(200)
    end

    it "can access form submissions too" do
      login_as(other_admin, scope: :account)
      visit admin_form_submissions_path

      expect(page).to have_content("Form Submissions")
      expect(page.status_code).to eq(200)
    end

    it "sees full navigation like before" do
      login_as(other_admin, scope: :account)
      visit admin_root_path

      expect(page).to have_link("Form Submissions")
      expect(page).to have_link("Buildings")
      expect(page).to have_link("Spaces")
      expect(page).to have_link("Events")
    end
  end

  context "Regular user with no admin group" do
    it "can access all admin pages like before (read-only access)" do
      login_as(regular_user, scope: :account)
      visit admin_form_submissions_path

      expect(page).to have_content("Form Submissions")
      expect(page.status_code).to eq(200)
    end

    it "can access buildings admin (read-only - cannot manage)" do
      login_as(regular_user, scope: :account)
      visit admin_buildings_path

      expect(page).to have_content("Buildings")
      expect(page.status_code).to eq(200)
    end

    it "can see all navigation items" do
      login_as(regular_user, scope: :account)
      visit admin_root_path

      expect(page).to have_link("Spaces")
      expect(page).to have_link("Groups")
      expect(page).to have_link("Services")
      expect(page).to have_link("Form Submissions")
      expect(page).to have_link("Buildings")
    end
  end
end
