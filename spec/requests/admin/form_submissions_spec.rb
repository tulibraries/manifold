# frozen_string_literal: true

require "rails_helper"
require "csv"

RSpec.describe "Admin Form Submissions", type: :request do
  let(:form_submissions_admin) do
    FactoryBot.create(:account, :form_submissions_admin)
  end

  describe "GET /admin/form_submissions" do
    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "renders the form submissions dashboard" do
        get admin_form_submissions_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Form Submissions")
      end
    end
  end

  context "when unauthenticated" do
    it "redirects to the sign-in page" do
      get admin_form_submissions_path

      expect(response).to redirect_to(new_account_session_path)
    end
  end

  context "when authenticated as a student without Form Submission access" do
    let(:account) { FactoryBot.create(:account, :student) }

    before do
      sign_in account
    end

    it "redirects away from Form Submissions" do
      get admin_form_submissions_path

      expect(response).to redirect_to(admin_webpages_path)
    end
  end

  describe "GET /admin/form_submissions/av_requests" do
    let!(:av_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "av-requests",
        form_attributes: {
          "name" => "AV Request User",
          "collection_title" => "Complete AV Collection",
          "identifier" => "AV Item 1",
          "format" => "film",
          "collection_title_01" => "Incomplete AV Collection",
          "identifier_01" => "AV Item 2",
        },
      )
    end

    let!(:copy_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "copy-requests",
        form_attributes: { "name" => "Copy Request User" }
      )
    end

    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "lists AV request submissions only" do
        get av_requests_admin_form_submissions_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("AV Request User")
        expect(response.body).to_not include("Copy Request User")

        expect(response.body).to include("1 request")
      end
    end

    context "when authenticated without Form Submission manage access" do
      let(:account) { FactoryBot.create(:account) }

      before do
        sign_in account
      end

      it "redirects away from Form Submissions" do
        get av_requests_admin_form_submissions_path

        expect(response).to redirect_to(admin_people_path)
      end
    end
  end

  describe "GET /admin/form_submissions/copy_requests" do
    let!(:av_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "av-requests",
        form_attributes: { "name" => "AV Request User" }
      )
    end

    let!(:copy_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "copy-requests",
        form_attributes: {
          "name" => "Copy Request User",
          "collection_title" => "Complete Copy Collection",
          "box" => "Box 1",
          "folder" => "Folder 1",
          "identifier" => "Copy Item 1",
          "format" => "pdf",
          "collection_title_01" => "Incomplete Copy Collection",
          "box_01" => "Box 2",
          "folder_01" => "Folder 2",
          "identifier_01" => "Copy Item 2",
        },
      )
    end

    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "lists Copy request submissions only" do
        get copy_requests_admin_form_submissions_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Copy Request User")
        expect(response.body).to include("1 request")
        expect(response.body).to_not include("AV Request User")
      end
    end

    context "when authenticated without Form Submission manage access" do
      let(:account) { FactoryBot.create(:account) }

      before do
        sign_in account
      end

      it "redirects away from Form Submissions" do
        get copy_requests_admin_form_submissions_path

        expect(response).to redirect_to(admin_people_path)
      end
    end
  end

  describe "GET /admin/form_submissions/:id" do
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

    let!(:nested_av_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "av-requests",
        form_attributes: {
          "form" => {
            "name" => "Nested AV User",
            "collection_title" => "Nested Collection",
            "identifier" => "Nested Item",
            "notes" => "Nested notes",
            "format" => "video",
          },
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

    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "shows an AV request submission" do
        get admin_form_submission_path(av_submission)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("AV Request User")
        expect(response.body).to include("AV Request ##{av_submission.id}")

        expect(response.body).to include("Outside Vendor Fees")
        expect(response.body).to include("AV Collection")
        expect(response.body).to include("AV Item 1")
        expect(response.body).to include("Handle with care")
        expect(response.body).to include("Film: $30 per minute")

        expect(response.body).to include("Request 2")
        expect(response.body).to include("Second AV Collection")
        expect(response.body).to include("AV Item 2")
        expect(response.body).to include("Second request notes")
        expect(response.body).to include("Audio: $50 per tape/reel")

        expect(response.body).not_to include("Estimated Pages")
      end

      it "shows an AV request with nested form attributes" do
        get admin_form_submission_path(nested_av_submission)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Nested AV User")
        expect(response.body).to include("Nested Collection")
        expect(response.body).to include("Nested Item")
        expect(response.body).to include("Nested notes")
        expect(response.body).to include("Video: $50 per tape")
      end

      it "shows a Copy request submission when form_type is specified" do
        get admin_form_submission_path(
          copy_submission,
          form_type: "copy-requests",
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Copy Request User")
        expect(response.body).to include("Copy Request ##{copy_submission.id}")

        expect(response.body).to include("Copy Collection")
        expect(response.body).to include("Box 2")
        expect(response.body).to include("Folder 3")
        expect(response.body).to include("Document 4")
        expect(response.body).to include("Estimated Pages")
        expect(response.body).to include("12")
        expect(response.body).to include("PDF: $0.50 per page")

        expect(response.body).to include("Request 2")
        expect(response.body).to include("Second Copy Collection")
        expect(response.body).to include("Box 4")
        expect(response.body).to include("Folder 5")
        expect(response.body).to include("Document 6")
        expect(response.body).to include("24")
        expect(response.body).to include("Photocopy: $0.50 per page plus postage")

        expect(response.body).not_to include("Outside Vendor Fees")
      end

      it "redirects when the submission does not match the requested form type" do
        get admin_form_submission_path(
          copy_submission,
          form_type: "av-requests"
        )

        expect(response).to redirect_to(admin_form_submissions_path)
      end

      it "redirects for a nonexistent submission" do
        get admin_form_submission_path(-1)

        expect(response).to redirect_to(admin_form_submissions_path)
      end

      it "redirects for a Copy request when form_type is omitted" do
        get admin_form_submission_path(copy_submission)

        expect(response).to redirect_to(admin_form_submissions_path)
      end
    end
  end

  describe "GET /admin/form_submissions/export_av_requests_csv.csv" do
    let!(:av_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "av-requests",
        form_attributes: {
          "name" => "AV Request User",
          "email" => "av@example.com",
          "address" => "123 Main St\nPhiladelphia, PA",
          "outside_vendor_fees" => "1",
          "duplication_limits" => true,
          "copyright_acknowledgment" => "0",
          "collection_title" => "Collection A",
          "identifier" => "Item 1",
          "notes" => "Test notes",
          "format" => "film",
          "collection_title_01" => "Collection A2",
          "identifier_01" => "Item 2",
          "notes_01" => "Second AV request",
          "format_01" => "audio",
        }
      )
    end

    let!(:copy_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "copy-requests",
        form_attributes: { "name" => "Copy Request User" }
      )
    end

    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "exports AV requests as CSV" do
        get export_av_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/csv")
        expect(response.headers["Content-Disposition"]).to include("av_requests_")

        csv = CSV.parse(response.body, headers: true)

        expect(response.body).to include("AV Request User")
        expect(response.body).to include("av@example.com")
        expect(response.body).to include("123 Main St | Philadelphia, PA")
        expect(response.body).to include("Collection A")
        expect(response.body).to include("Item 1")
        expect(response.body).to include("Film: $30 per minute")

        expect(response.body).not_to include("Copy Request User")

        expected_headers = [
          "ID",
          "Submitted At",
          "Name",
          "Email",
          "Phone",
          "Affiliation",
          "Address",
          "Outside Vendor Fees",
          "Duplication Limits",
          "Copyright Acknowledgment",
        ]

        (1..10).each do |request_num|
          expected_headers.concat(
            [
              "Request #{request_num} - Collection Title",
              "Request #{request_num} - Identifier/File Name/Description",
              "Request #{request_num} - Notes",
              "Request #{request_num} - Format",
            ],
          )
        end

        expect(csv.headers).to eq(expected_headers)

        row = csv.first

        expect(row["Name"]).to eq("AV Request User")
        expect(row["Address"]).to eq("123 Main St | Philadelphia, PA")
        expect(row["Outside Vendor Fees"]).to eq("Yes")

        expect(row["Request 1 - Collection Title"]).to eq("Collection A")
        expect(row["Request 1 - Format"]).to eq("Film: $30 per minute")

        expect(row["Request 2 - Collection Title"]).to eq("Collection A2")
        expect(row["Request 2 - Identifier/File Name/Description"]).to eq("Item 2")
        expect(row["Request 2 - Notes"]).to eq("Second AV request")
        expect(row["Request 2 - Format"]).to eq("Audio: $50 per tape/reel")
      end

      it "exports nested form attributes" do
        nested_submission = FactoryBot.create(
          :form_submission,
          form_type: "av-requests",
          form_attributes: {
            "form" => {
              "name" => "Nested CSV User",
              "email" => "nested@example.com",
              "collection_title" => "Nested CSV Collection",
              "identifier" => "Nested CSV Item",
              "format" => "audio",
            },
          },
        )

        get export_av_requests_csv_admin_form_submissions_path(format: :csv)

        csv = CSV.parse(response.body, headers: true)
        row = csv.find { |candidate| candidate["ID"] == nested_submission.id.to_s }

        expect(row["Name"]).to eq("Nested CSV User")
        expect(row["Request 1 - Collection Title"]).to eq("Nested CSV Collection")
        expect(row["Request 1 - Identifier/File Name/Description"]).to eq("Nested CSV Item")
        expect(row["Request 1 - Format"]).to eq("Audio: $50 per tape/reel")
      end

      it "includes an error row when a submission cannot be processed" do
        relation = instance_double(ActiveRecord::Relation, order: [av_submission])

        allow(FormSubmission)
          .to receive(:where)
          .with(form_type: "av-requests")
          .and_return(relation)

        allow(av_submission)
          .to receive(:form_attributes)
          .and_raise(StandardError, "boom")

        get export_av_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/csv")
        expect(response.body).to include("Error decrypting data")
      end
    end

    context "when authenticated without Form Submission manage access" do
      let(:account) { FactoryBot.create(:account) }

      before do
        sign_in account
      end

      it "redirects away from Form Submissions" do
        get export_av_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to redirect_to(admin_people_path)
      end
    end
  end

  describe "GET /admin/form_submissions/export_copy_requests_csv.csv" do
    let!(:copy_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "copy-requests",
        form_attributes: {
          "name" => "Copy Request User",
          "email" => "copy@example.com",
          "address" => "456 Broad St\nPhiladelphia, PA",
          "duplication_limits" => "1",
          "copyright_acknowledgment" => true,
          "collection_title" => "Collection B",
          "box" => "Box 2",
          "folder" => "Folder 3",
          "identifier" => "Document 4",
          "estimated_pages" => "12",
          "format" => "pdf",
          "collection_title_01" => "Collection B2",
          "box_01" => "Box 4",
          "folder_01" => "Folder 5",
          "identifier_01" => "Document 6",
          "estimated_pages_01" => "24",
          "format_01" => "photocopy",
        }
      )
    end

    let!(:av_submission) do
      FactoryBot.create(
        :form_submission,
        form_type: "av-requests",
        form_attributes: { "name" => "AV Request User" }
      )
    end

    context "when authenticated as a Form Submissions admin" do
      before do
        sign_in form_submissions_admin
      end

      it "exports Copy requests as CSV" do
        get export_copy_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/csv")
        expect(response.headers["Content-Disposition"]).to include("copy_requests_")

        csv = CSV.parse(response.body, headers: true)

        expect(response.body).to include("Copy Request User")
        expect(response.body).to include("copy@example.com")
        expect(response.body).to include("456 Broad St | Philadelphia, PA")
        expect(response.body).to include("Collection B")
        expect(response.body).to include("Box 2")
        expect(response.body).to include("Folder 3")
        expect(response.body).to include("Document 4")
        expect(response.body).to include("12")
        expect(response.body).to include("PDF: $0.50 per page")

        expect(response.body).not_to include("AV Request User")

        expected_headers = [
          "ID",
          "Submitted At",
          "Name",
          "Email",
          "Phone",
          "Affiliation",
          "Address",
          "Duplication Limits",
          "Copyright Acknowledgment",
        ]

        (1..10).each do |request_num|
          expected_headers.concat(
            [
              "Request #{request_num} - Collection Title",
              "Request #{request_num} - Box",
              "Request #{request_num} - Folder",
              "Request #{request_num} - Title/Identifier/File Name/Description",
              "Request #{request_num} - Estimated Number of Pages",
              "Request #{request_num} - Format",
            ],
          )
        end

        expect(csv.headers).to eq(expected_headers)

        row = csv.first

        expect(row["Name"]).to eq("Copy Request User")
        expect(row["Address"]).to eq("456 Broad St | Philadelphia, PA")
        expect(row["Duplication Limits"]).to eq("Yes")
        expect(row["Copyright Acknowledgment"]).to eq("Yes")

        expect(row["Request 1 - Collection Title"]).to eq("Collection B")
        expect(row["Request 1 - Box"]).to eq("Box 2")
        expect(row["Request 1 - Folder"]).to eq("Folder 3")
        expect(row["Request 1 - Estimated Number of Pages"]).to eq("12")
        expect(row["Request 1 - Format"]).to eq("PDF: $0.50 per page")

        expect(row["Request 2 - Collection Title"]).to eq("Collection B2")
        expect(row["Request 2 - Box"]).to eq("Box 4")
        expect(row["Request 2 - Folder"]).to eq("Folder 5")
        expect(row["Request 2 - Title/Identifier/File Name/Description"]).to eq("Document 6")
        expect(row["Request 2 - Estimated Number of Pages"]).to eq("24")
        expect(row["Request 2 - Format"]).to eq("Photocopy: $0.50 per page plus postage")
      end

      it "includes an error row when a submission cannot be processed" do
        relation = instance_double(ActiveRecord::Relation, order: [copy_submission])

        allow(FormSubmission)
          .to receive(:where)
          .with(form_type: "copy-requests")
          .and_return(relation)

        allow(copy_submission)
          .to receive(:form_attributes)
          .and_raise(StandardError, "boom")

        get export_copy_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq("text/csv")
        expect(response.body).to include("Error decrypting data")
      end
    end

    context "when authenticated without Form Submission manage access" do
      let(:account) { FactoryBot.create(:account) }

      before do
        sign_in account
      end

      it "redirects away from Form Submissions" do
        get export_copy_requests_csv_admin_form_submissions_path(format: :csv)

        expect(response).to redirect_to(admin_people_path)
      end

    end
  end
end
