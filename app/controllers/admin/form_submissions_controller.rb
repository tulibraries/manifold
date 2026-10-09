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
        csv_data = FormSubmissionCsvExportService.call(@form_submissions, form_type: "av-requests")
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
        csv_data = FormSubmissionCsvExportService.call(@form_submissions, form_type: "copy-requests")
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
end
