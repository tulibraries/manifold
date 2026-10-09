# frozen_string_literal: true

require "csv"

class FormSubmissionCsvExportService < ApplicationService
  def self.call(submissions, form_type:)
    new(submissions, form_type: form_type).call
  end

  def initialize(submissions, form_type:)
    @submissions = submissions
    @form_type = form_type
  end

  def call
    CSV.generate(headers: true) do |csv|
      csv << headers

      @submissions.each do |submission|
        csv << submission_row(submission)
      rescue => e
        Rails.logger.error(
          "Error processing #{request_type_label} request submission #{submission.id}: #{e.message}",
        )

        csv << [
          submission.id,
          submission.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          "Error decrypting data",
        ]
      end
    end
  end

  private

    def headers
      fixed_headers = [
        "ID",
        "Submitted At",
        "Name",
        "Email",
        "Phone",
        "Affiliation",
        "Address",
      ]

      fixed_headers << "Outside Vendor Fees" if @form_type == "av-requests"

      fixed_headers.concat([
        "Duplication Limits",
        "Copyright Acknowledgment",
      ])

      request_fields = Form::RequestDefinition.request_fields(@form_type)

      Form::RequestDefinition.slots.each do |slot|
        request_fields.each do |field|
          label = Form::RequestDefinition.field_label(
            @form_type,
            field,
            surface: :csv,
          )

          fixed_headers << "Request #{slot + 1} - #{label}"
        end
      end

      fixed_headers
    end

    def submission_row(submission)
      raw_attributes = submission.form_attributes || {}
      attributes = raw_attributes["form"] || raw_attributes

      row = [
        submission.id,
        submission.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        attributes["name"],
        attributes["email"],
        attributes["phone"],
        attributes["affiliation"],
        attributes["address"]&.gsub(/\n/, " | "),
      ]

      if @form_type == "av-requests"
        row << boolean_label(attributes["outside_vendor_fees"])
      end

      row << boolean_label(attributes["duplication_limits"])
      row << boolean_label(attributes["copyright_acknowledgment"])

      request_fields = Form::RequestDefinition.request_fields(@form_type)

      Form::RequestDefinition.slots.each do |slot|
        request_fields.each do |field|
          key = Form::RequestDefinition.field_key(field, slot)
          value = attributes[key]

          if field == :format && value.present?
            value = Form::RequestDefinition.format_label(@form_type, value)
          end

          row << value
        end
      end

      row
    end

    def boolean_label(value)
      value == "1" || value == true ? "Yes" : "No"
    end

    def request_type_label
      @form_type == "av-requests" ? "AV" : "copy"
    end
end
