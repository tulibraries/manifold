# frozen_string_literal: true

require "rails_helper"

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
        form_attributes: { "name" => "AV Request User" }
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
        form_attributes: { "name" => "Copy Request User" }
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
        form_attributes: { "name" => "AV Request User" }
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

      it "shows an AV request submission" do
        get admin_form_submission_path(av_submission)

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("AV Request User")
        expect(response.body).to include("AV Request ##{av_submission.id}")
      end

      it "shows a Copy request submission when form_type is specified" do
        get admin_form_submission_path(
          copy_submission,
          form_type: "copy-requests"
        )

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Copy Request User")
        expect(response.body).to include("Copy Request ##{copy_submission.id}")
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
          "format" => "film"
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

        expect(response.body).to include("AV Request User")
        expect(response.body).to include("av@example.com")
        expect(response.body).to include("123 Main St | Philadelphia, PA")
        expect(response.body).to include("Collection A")
        expect(response.body).to include("Item 1")
        expect(response.body).to include("Film: $30 per minute")

        expect(response.body).not_to include("Copy Request User")
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
          "format" => "pdf"
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
