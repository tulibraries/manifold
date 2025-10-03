# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Form Submission Admin Access", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  let!(:form_submission_admin_group) do
    FactoryBot.create(:admin_group,
      name: "Form Submissions Admin",
      managed_entities: ["FormSubmission"]
    )
  end

  let!(:form_submission_admin_user) do
    FactoryBot.create(:account,
      email: "formadmin@temple.edu",
      name: "Form Admin User",
      admin_group: form_submission_admin_group
    )
  end

  let!(:form_submission) do
    FactoryBot.create(:form_submission,
      form_type: "test-form",
      form_attributes: { name: "Test Submission" }
    )
  end

  context "when user has Form Submission-only admin access" do
    before do
      login_as(form_submission_admin_user, scope: :account)
      visit admin_root_path
    end

    it "shows only Form Submissions in navigation" do
      # Should see Form Submissions
      expect(page).to have_link("Form Submissions")

      # Should NOT see admin-only resources
      expect(page).not_to have_link("Admin Groups")
      expect(page).not_to have_link("Accounts")

      # Should NOT see other manageable entities
      expect(page).not_to have_link("Blogs")
      expect(page).not_to have_link("Events")
      expect(page).not_to have_link("Buildings")
    end

    it "can access Form Submissions index" do
      click_link "Form Submissions"
      expect(page).to have_current_path(admin_form_submissions_path)
      expect(page).to have_content("Form Submissions")
    end

    it "cannot access Admin Groups directly" do
      visit admin_admin_groups_path
      expect(page).to have_current_path(admin_form_submissions_path)
      expect(page).to have_content("You are not authorized to access this page")
    end

    it "cannot access Accounts directly" do
      visit admin_accounts_path
      expect(page).to have_current_path(admin_form_submissions_path)
      expect(page).to have_content("You are not authorized to access this page")
    end
  end
end
