# frozen_string_literal: true

require "rails_helper"
require "csv"

RSpec.describe FormSubmissionCsvExportService do
  describe ".call" do
    context "with AV requests" do
      it "generates headers without data rows for an empty collection" do
        csv_data = described_class.call([], form_type: "av-requests")
        csv = CSV.parse(csv_data, headers: true)

        expect(csv.size).to eq(0)
        expect(csv.headers.first(10)).to eq(
          [
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
          ],
        )
        expect(csv.headers.size).to eq(50)
      end

      it "continues processing submissions after a failure" do
  timestamp = Time.zone.local(2026, 10, 9, 12, 0, 0)

  failed_submission = instance_double(
    FormSubmission,
    id: 1,
    created_at: timestamp,
  )

  valid_submission = instance_double(
    FormSubmission,
    id: 2,
    created_at: timestamp,
    form_attributes: { "name" => "Valid CSV User" },
  )

  allow(failed_submission).to receive(:form_attributes)
    .and_raise(StandardError, "Decryption failed")

  allow(Rails.logger).to receive(:error)

  csv_data = described_class.call(
    [failed_submission, valid_submission],
    form_type: "av-requests",
  )

  csv = CSV.parse(csv_data, headers: true)

  expect(csv.size).to eq(2)
  expect(csv[0]["Name"]).to eq("Error decrypting data")
  expect(csv[1]["Name"]).to eq("Valid CSV User")

  expect(Rails.logger).to have_received(:error).with(
    "Error processing AV request submission 1: Decryption failed",
  )
end
    end

    context "with Copy requests" do
      it "generates headers without data rows for an empty collection" do
        csv_data = described_class.call([], form_type: "copy-requests")
        csv = CSV.parse(csv_data, headers: true)

        expect(csv.size).to eq(0)
        expect(csv.headers.first(9)).to eq(
          [
            "ID",
            "Submitted At",
            "Name",
            "Email",
            "Phone",
            "Affiliation",
            "Address",
            "Duplication Limits",
            "Copyright Acknowledgment",
          ],
        )
        expect(csv.headers.size).to eq(69)
        expect(csv.headers).not_to include("Outside Vendor Fees")
      end
    end
  end
end
