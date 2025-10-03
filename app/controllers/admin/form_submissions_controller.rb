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
    @page_title = "AV Request Submissions"
    render "collection"
  end

  def copy_requests
    @form_submissions = FormSubmission.where(form_type: "copy-requests")
                                      .order(created_at: :desc)
                                      .page(params[:page])
                                      .per(20)
    @page_title = "Copy Request Submissions"
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
    @page_title = form_type == "av-requests" ? "AV Request Details" : "Copy Request Details"
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
        (0..9).each do |i|
          request_num = i + 1
          header_row << "Request #{request_num} - Collection Title"
          header_row << "Request #{request_num} - Identifier/File Name/Description"
          header_row << "Request #{request_num} - Notes"
          header_row << "Request #{request_num} - Format"
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
            (0..9).each do |i|
              collection_field = i == 0 ? "collection_title" : "collection_title_#{i.to_s.rjust(2, '0')}"
              identifier_field = i == 0 ? "identifier" : "identifier_#{i.to_s.rjust(2, '0')}"
              notes_field = i == 0 ? "notes" : "notes_#{i.to_s.rjust(2, '0')}"
              format_field = i == 0 ? "format" : "format_#{i.to_s.rjust(2, '0')}"

              # Add the format labels for better readability
              format_value = attributes[format_field]
              if format_value.present?
                format_labels = {
                  "film" => "Film: $30 per minute",
                  "video" => "Video: $50 per tape",
                  "audio" => "Audio: $50 per tape/reel"
                }
                format_value = format_labels[format_value] || format_value
              end

              row << attributes[collection_field]
              row << attributes[identifier_field]
              row << attributes[notes_field]
              row << format_value
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

        # Add request fields (up to 10 requests with 5 fields each)
        (0..9).each do |i|
          request_num = i + 1
          header_row << "Request #{request_num} - Collection Title"
          header_row << "Request #{request_num} - Box"
          header_row << "Request #{request_num} - Folder"
          header_row << "Request #{request_num} - Title/Identifier/File Name/Description"
          header_row << "Request #{request_num} - Estimated Number of Pages"
          header_row << "Request #{request_num} - Format"
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

            # Add request fields (6 fields per request for copy requests)
            (0..9).each do |i|
              collection_field = i == 0 ? "collection_title" : "collection_title_#{i.to_s.rjust(2, '0')}"
              box_field = i == 0 ? "box" : "box_#{i.to_s.rjust(2, '0')}"
              folder_field = i == 0 ? "folder" : "folder_#{i.to_s.rjust(2, '0')}"
              identifier_field = i == 0 ? "identifier" : "identifier_#{i.to_s.rjust(2, '0')}"
              pages_field = i == 0 ? "estimated_pages" : "estimated_pages_#{i.to_s.rjust(2, '0')}"
              format_field = i == 0 ? "format" : "format_#{i.to_s.rjust(2, '0')}"

              # Add the format labels for better readability
              format_value = attributes[format_field]
              if format_value.present?
                format_labels = {
                  "tiff" => "TIFF (600 DPI): $5 per image",
                  "pdf" => "PDF: $0.50 per page",
                  "photocopy" => "Photocopy: $0.50 per page plus postage"
                }
                format_value = format_labels[format_value] || format_value
              end

              row << attributes[collection_field]
              row << attributes[box_field]
              row << attributes[folder_field]
              row << attributes[identifier_field]
              row << attributes[pages_field]
              row << format_value
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
