# frozen_string_literal: true

class BatchRequestsController < ApplicationController
  def index
    # Show available form types for batch processing
  end

  def new
    @batch_request_type = params[:type] || "purchase-request"
    @form_info = FormInfo.find_by(slug: @batch_request_type)

    if @form_info.nil?
      redirect_to root_path, alert: "Form type not found"
      return
    end

    # Initialize 10 empty forms for batch creation
    @forms = Array.new(10) { Form.new }
    @title = "Batch Create: #{@form_info.title}"
  end

  def create
    @batch_request_type = params[:batch_request][:form_type]
    @form_info = FormInfo.find_by(slug: @batch_request_type)

    if @form_info.nil?
      redirect_to root_path, alert: "Form type not found"
      return
    end

    @forms = []
    successful_submissions = []
    failed_submissions = []

    # Process each form in the batch
    params[:batch_request][:forms].each_with_index do |form_params, index|
      next if form_params.blank? || form_params.values.all?(&:blank?)

      form = Form.new(form_params.merge(
                        form_type: @batch_request_type,
                        recipients: @form_info.recipients,
                        title: @form_info.title
      ))
      form.request = request

      @forms << form

      if form.deliver
        # Persist each successful form submission
        persist_form!(form_params, @batch_request_type)
        successful_submissions << (index + 1)
      else
        failed_submissions << (index + 1)
      end
    end

    if failed_submissions.empty?
      redirect_to new_batch_request_path(type: @batch_request_type),
                  notice: "Successfully submitted #{successful_submissions.count} requests!"
    else
      @forms = Array.new(10) { Form.new } # Reset for retry
      flash.now[:alert] = "Failed to submit requests ##{failed_submissions.join(', ')}. Please check and try again."
      render :new
    end
  end

  private

    def persist_form!(form_params, form_type)
      # Remove form_type and recipients as they're handled separately
      cleaned_params = form_params.except(:form_type, :recipients)

      FormSubmission.create(
        form_type: form_type,
        form_attributes: cleaned_params
      )
    end

    def batch_request_params
      params.require(:batch_request).permit(
        :form_type,
        forms: [
          # Personal information fields
          :name, :email, :tu_id, :phone, :department, :affiliation, :affiliation_other,
          :organizing_name, :organizing_phone, :organizing_email,
          :financial_name, :financial_phone, :financial_email,

          # Book/material related fields
          :author, :title, :book_title, :missing_title, :recall_title, :year, :publisher,
          :isbn, :call_number, :edition,
          :material_type, :material_type_other, :format_preference, :format_preference_other,
          :reason_for_request, :source_of_information, :reason_for_purchase,
          :substitute_edition, :pickup_location,

          # Course/instruction related fields
          :course_title, :course_code, :course_number, :class_time, :class_days,
          :number_of_students, :instruction_mode,

          # Date/time fields
          :preferred_date, :preferred_time, :first_choice_date, :second_choice_date,
          :requested_date, :cancellation_date,

          # General fields
          :comments, :description, :group, :foapal,

          # Event/space related fields
          :event_title, :event_space, :attendees, :setup_style, :av_support, :catering,
          :additional_setup_requirements, :date_of_event, :event_start, :event_end,

          # Other specialized fields
          :easel, :minors, :requestor, :template_course_project, :bachelor_degree,
          :institution_of_degree, :overall_gpa, :degrees_earned, :degree_program,
          :faculty_advisor, :degree_year, :personal_statement, :policy_check
        ]
      )
    end
end
