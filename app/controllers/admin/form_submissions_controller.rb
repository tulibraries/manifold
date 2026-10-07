# frozen_string_literal: true

class Admin::FormSubmissionsController < Admin::ApplicationController
  def index
    # Main dashboard showing both form types with download buttons
    @page_title = "Form Submissions"
  end

  def av_requests
    @form_submissions = FormSubmission.where(form_type: "av-requests")
                                      .order(created_at: :desc)
                                      .page(params[:page])
                                      .per(20)
    @page_title = Form::RequestDefinition.collection_title("av-requests")
    render "collection"
  end

  def copy_requests
    @form_submissions = FormSubmission.where(form_type: "copy-requests")
                                      .order(created_at: :desc)
                                      .page(params[:page])
                                      .per(20)
    @page_title = Form::RequestDefinition.collection_title("copy-requests")
    render "collection"
  end

  def export_av_requests_csv
    @form_submissions = FormSubmission.where(form_type: "av-requests").order(created_at: :desc)

    respond_to do |format|
      format.csv do
        csv_data = generate_av_requests_csv(@form_submissions)
        send_data csv_data,
                  filename: "av_requests_#{Date.current.strftime('%Y%m%d')}.csv",
                  type: "text/csv"
      end
    end
  end

  def export_copy_requests_csv
    @form_submissions = FormSubmission.where(form_type: "copy-requests").order(created_at: :desc)

    respond_to do |format|
      format.csv do
        csv_data = generate_copy_requests_csv(@form_submissions)
        send_data csv_data,
                  filename: "copy_requests_#{Date.current.strftime('%Y%m%d')}.csv",
                  type: "text/csv"
      end
    end
  end

  def show
    form_type = params[:form_type] || "av-requests"
    @form_submission = FormSubmission.where(form_type: form_type).find(params[:id])
    @page_title = Form::RequestDefinition.detail_title(form_type)
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_form_submissions_path, alert: "Form submission not found or not accessible."
  end

  private

    def generate_av_requests_csv(submissions)
      require "csv"

      CSV.generate(headers: true) do |csv|
        # Create header row for AV requests
        header_row = ["ID", "Submitted At", "Name", "Email", "Phone", "Affiliation", "Address", "Outside Vendor Fees", "Duplication Limits", "Copyright Acknowledgment"]

        # Add request fields (up to 10 requests with 4 fields each)
        request_fields = Form::RequestDefinition.request_fields("av-requests")

        Form::RequestDefinition.slots.each do |slot|
          request_num = slot + 1

          request_fields.each do |field|
            label = Form::RequestDefinition.field_label("av-requests", field, surface: :csv)
            header_row << "Request #{request_num} - #{label}"
          end
        end

        csv << header_row
        # Add data rows for AV requests
        submissions.each do |submission|
          begin
            # Decrypt the form attributes and handle nested structure
            raw_attributes = submission.form_attributes || {}
            attributes = raw_attributes["form"] || raw_attributes

            row = [
              submission.id,
              submission.created_at.strftime("%Y-%m-%d %H:%M:%S"),
              attributes["name"],
              attributes["email"],
              attributes["phone"],
              attributes["affiliation"],
              attributes["address"]&.gsub(/\n/, " | "), # Replace line breaks with pipe for CSV
              attributes["outside_vendor_fees"] == "1" || attributes["outside_vendor_fees"] == true ? "Yes" : "No",
              attributes["duplication_limits"] == "1" || attributes["duplication_limits"] == true ? "Yes" : "No",
              attributes["copyright_acknowledgment"] == "1" || attributes["copyright_acknowledgment"] == true ? "Yes" : "No"
            ]

            # Add request fields (4 fields per request)
            Form::RequestDefinition.slots.each do |slot|
              request_fields.each do |field|
                key = Form::RequestDefinition.field_key(field, slot)
                value = attributes[key]

                value = Form::RequestDefinition.format_label("av-requests", value, surface: :csv) if field == :format && value.present?

                row << value
              end
            end

            csv << row
          rescue => e
            Rails.logger.error "Error processing AV request submission #{submission.id}: #{e.message}"
            # Add a row with just the basic info if decryption fails
            csv << [submission.id, submission.created_at.strftime("%Y-%m-%d %H:%M:%S"), "Error decrypting data"]
          end
        end
      end
    end

    def generate_copy_requests_csv(submissions)
      require "csv"

      CSV.generate(headers: true) do |csv|
        # Create header row for Copy requests
        header_row = ["ID", "Submitted At", "Name", "Email", "Phone", "Affiliation", "Address", "Duplication Limits", "Copyright Acknowledgment"]

        # Add request fields (up to 10 requests with 6 fields each)
        request_fields = Form::RequestDefinition.request_fields("copy-requests")

        Form::RequestDefinition.slots.each do |slot|
          request_num = slot + 1

          request_fields.each do |field|
            label = Form::RequestDefinition.field_label("copy-requests", field, surface: :csv)
            header_row << "Request #{request_num} - #{label}"
          end
        end

        csv << header_row

        # Add data rows for Copy requests
        submissions.each do |submission|
          begin
            # Decrypt the form attributes and handle nested structure
            raw_attributes = submission.form_attributes || {}
            attributes = raw_attributes["form"] || raw_attributes

            row = [
              submission.id,
              submission.created_at.strftime("%Y-%m-%d %H:%M:%S"),
              attributes["name"],
              attributes["email"],
              attributes["phone"],
              attributes["affiliation"],
              attributes["address"]&.gsub(/\n/, " | "), # Replace line breaks with pipe for CSV
              attributes["duplication_limits"] == "1" || attributes["duplication_limits"] == true ? "Yes" : "No",
              attributes["copyright_acknowledgment"] == "1" || attributes["copyright_acknowledgment"] == true ? "Yes" : "No"
            ]

            # Add request fields (6 fields per request)
            Form::RequestDefinition.slots.each do |slot|
              request_fields.each do |field|
                key = Form::RequestDefinition.field_key(field, slot)
                value = attributes[key]

                value = Form::RequestDefinition.format_label("copy-requests", value, surface: :csv) if field == :format && value.present?

                row << value
              end
            end

            csv << row
          rescue => e
            Rails.logger.error "Error processing copy request submission #{submission.id}: #{e.message}"
            # Add a row with just the basic info if decryption fails
            csv << [submission.id, submission.created_at.strftime("%Y-%m-%d %H:%M:%S"), "Error decrypting data"]
          end
        end
      end
    end
end
