# frozen_string_literal: true

class Admin::FormSubmissionsController < Admin::ApplicationController
  def index
    # Main dashboard showing both form types with download buttons
    @page_title = "Form Submissions"
  end

  def av_requests
    render_collection("av-requests")
  end

  def copy_requests
    render_collection("copy-requests")
  end

  def export_av_requests_csv
    export_requests_csv("av-requests", "av_requests")
  end

  def export_copy_requests_csv
    export_requests_csv("copy-requests", "copy_requests")
  end

  def show
    form_type = params[:form_type] || "av-requests"
    @form_submission = submissions_for(form_type).find(params[:id])
    @page_title = Form::RequestDefinition.detail_title(form_type)
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_form_submissions_path, alert: "Form submission not found or not accessible."
  end

  private

    def submissions_for(form_type)
      FormSubmission.where(form_type: form_type)
    end

    def render_collection(form_type)
      @form_submissions = submissions_for(form_type)
                          .order(created_at: :desc)
                          .page(params[:page])
                          .per(20)
      @page_title = Form::RequestDefinition.collection_title(form_type)
      render "collection"
    end

    def export_requests_csv(form_type, filename_prefix)
      @form_submissions = submissions_for(form_type).order(created_at: :desc)

      respond_to do |format|
        format.csv do
          csv_data = FormSubmissionCsvExportService.call(@form_submissions, form_type: form_type)
          send_data csv_data,
                    filename: "#{filename_prefix}_#{Date.current.strftime('%Y%m%d')}.csv",
                    type: "text/csv"
        end
      end
    end
end
