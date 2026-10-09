# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin Form Submission Visual Baselines", type: :system, js: true do
  let(:form_submissions_admin) do
    FactoryBot.create(:account, :form_submissions_admin)
  end

  let!(:av_submission) do
    FactoryBot.create(
      :form_submission,
      form_type: "av-requests",
      form_attributes: {
        "name" => "AV Request User",
        "email" => "av@example.com",
        "address" => "123 Main St\nPhiladelphia, PA",
        "phone" => "555-1000",
        "affiliation" => "temple",
        "outside_vendor_fees" => "1",
        "duplication_limits" => "1",
        "copyright_acknowledgment" => "1",
        "collection_title" => "AV Collection",
        "identifier" => "AV Item 1",
        "notes" => "Handle with care",
        "format" => "film",
        "collection_title_01" => "Second AV Collection",
        "identifier_01" => "AV Item 2",
        "notes_01" => "Second request notes",
        "format_01" => "audio",
      },
    )
  end

  let!(:copy_submission) do
    FactoryBot.create(
      :form_submission,
      form_type: "copy-requests",
      form_attributes: {
        "name" => "Copy Request User",
        "email" => "copy@example.com",
        "address" => "456 Broad St\nPhiladelphia, PA",
        "phone" => "555-2000",
        "affiliation" => "non-temple",
        "duplication_limits" => "1",
        "copyright_acknowledgment" => "1",
        "collection_title" => "Copy Collection",
        "box" => "Box 2",
        "folder" => "Folder 3",
        "identifier" => "Document 4",
        "estimated_pages" => "12",
        "format" => "pdf",
        "collection_title_01" => "Second Copy Collection",
        "box_01" => "Box 4",
        "folder_01" => "Folder 5",
        "identifier_01" => "Document 6",
        "estimated_pages_01" => "24",
        "format_01" => "photocopy",
      },
    )
  end

  before do
    login_as(form_submissions_admin, scope: :account)
  end

  it "captures the AV request detail page" do
    visit admin_form_submission_path(av_submission)

    expect(page).to have_content("AV Collection")
    expect(page).to have_content("Second AV Collection")

    if %w[before after].include?(ENV["VISUAL_CAPTURE"])
      page.save_screenshot(
        Rails.root.join("tmp/visual-comparison", ENV["VISUAL_CAPTURE"], "av-detail.png").to_s,
        full: true,
      )
    end
  end

  it "captures the Copy request detail page" do
    visit admin_form_submission_path(copy_submission, form_type: "copy-requests")

    expect(page).to have_content("Copy Collection")
    expect(page).to have_content("Second Copy Collection")

    if %w[before after].include?(ENV["VISUAL_CAPTURE"])
      page.save_screenshot(
        Rails.root.join("tmp/visual-comparison", ENV["VISUAL_CAPTURE"], "copy-detail.png").to_s,
        full: true,
      )
    end
  end
end
