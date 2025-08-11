# frozen_string_literal: true

class Admin::FormSubmissionsController < Admin::ApplicationController
  def index
    @form_submissions = FormSubmission.where(form_type: 'new-form')
                                     .order(created_at: :desc)
                                     .limit(50)
  end

  def export_csv
    @form_submissions = FormSubmission.where(form_type: 'new-form').order(created_at: :desc)
    
    respond_to do |format|
      format.csv do
        csv_data = generate_csv(@form_submissions)
        send_data csv_data, 
                  filename: "new_form_submissions_#{Date.current.strftime('%Y%m%d')}.csv",
                  type: 'text/csv'
      end
    end
  end

  def show
    @form_submission = FormSubmission.where(form_type: 'new-form').find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_form_submissions_path, alert: 'Form submission not found or not accessible.'
  end

  private

  def generate_csv(submissions)
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      # Create header row with all possible form fields
      header_row = ['ID', 'Submitted At', 'Name', 'Email', 'TU ID', 'Phone', 'Department', 'Affiliation']
      
      # Add request fields (up to 9 based on the form model)
      (0..9).each do |i|
        if i == 0
          header_row << 'Request Title'
        else
          header_row << "Request Title #{i.to_s.rjust(2, '0')}"
        end
      end
      
      csv << header_row

      # Add data rows
      submissions.each do |submission|
        begin
          # Decrypt the form attributes and handle nested structure
          raw_attributes = submission.form_attributes || {}
          attributes = raw_attributes['form'] || raw_attributes
          
          row = [
            submission.id,
            submission.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            attributes['name'],
            attributes['email'],
            attributes['tu_id'],
            attributes['phone'],
            attributes['department'],
            attributes['affiliation']
          ]
          
          # Add request title fields
          (0..9).each do |i|
            field_name = i == 0 ? 'request_title' : "request_title_#{i.to_s.rjust(2, '0')}"
            row << attributes[field_name]
          end
          
          csv << row
        rescue => e
          Rails.logger.error "Error processing form submission #{submission.id}: #{e.message}"
          # Add a row with just the basic info if decryption fails
          csv << [submission.id, submission.created_at.strftime('%Y-%m-%d %H:%M:%S'), 'Error decrypting data']
        end
      end
    end
  end
end
