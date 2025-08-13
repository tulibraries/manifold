# frozen_string_literal: true

class FormsController < ApplicationController
  before_action :use_unsafe_params, only: [:persist_form!]
  def index
    form_groups = FormInfo.for_index.group_by(&:grouping)
    @form_groups = Hash[form_groups.sort_by { |k, v| k == "Administrative Services" ? 1 : 0 }]
    respond_to do |format|
      format.html {}
      format.json do
        @forms = form_objects_for_json
        render json: FormSerializer.new(@forms)
      end
    end
  end

  def show
    @form = Form.new
    if existing_forms.include? params[:id]
      @type = params[:id]
      info = FormInfo.find_by(slug: @type)
      if info.present?
        @title = info.title
        @intro = info.intro
        @recipients = info.recipients
      end
    else
      render "errors/not_found", status: :not_found
    end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request

    form_type = params[:form][:form_type]

    # Handle av-requests and copy-requests types - save to database instead of sending email
    if form_type == "av-requests"
      if save_to_database_only
        redirect_to form_path("av-requests", success: "av_requests")
      else
        redirect_to form_path("av-requests", success: "false")
      end
    elsif form_type == "copy-requests"
      if save_to_database_only
        redirect_to form_path("copy-requests", success: "copy_requests")
      else
        redirect_to form_path("copy-requests", success: "false")
      end
    else
      # For all other form types, use the existing email delivery system
      if @form.deliver
        persist_form!
        redirect_to forms_path(success: "true")
      else
        redirect_to forms_path(success: "false")
      end
    end
  end

  def persist_form!
    type = params[:form].delete(:form_type)
    recipients = params[:form].delete(:recipients)
    FormSubmission.create(
      form_type: type,
      form_attributes: use_unsafe_params
    )
  end

  def existing_forms
    Dir.glob(Rails.root.join("app/views/forms/*/"))
      .map { |template_path| template_path.split("/").last }
      .reject { |template_name| template_name == "shared" }
  end

  def form_objects_for_json
    existing_forms.map do |form|
        OpenStruct.new(
          id: form,
          label: t("manifold.forms.#{form.underscore}.title"),
          link: "#{request.base_url}/forms/#{form}",
          updated_at: DateTime.new(0)
        )
      end
  end

  def use_unsafe_params
    request.parameters
  end

  def save_to_database_only
    begin
      type = params[:form][:form_type]
      # For av-requests, we don't need recipients since we're not sending emails
      # Use the same unsafe params method that persist_form! uses
      form_params = use_unsafe_params[:form]

      # Validate required acknowledgments for av-requests
      if type == "av-requests"
        required_acknowledgments = ["outside_vendor_fees", "duplication_limits", "copyright_acknowledgment"]
        missing_acknowledgments = []

        required_acknowledgments.each do |field|
          value = form_params[field]
          # Check if the value represents a checked checkbox
          unless ["1", "1.0", 1, true, "true", "on"].include?(value)
            missing_acknowledgments << field.humanize
          end
        end

        if missing_acknowledgments.any?
          Rails.logger.error "Missing required acknowledgments: #{missing_acknowledgments.join(', ')}"
          return false
        end
      elsif type == "copy-requests"
        # Validate that each request has at least one pricing option selected
        # First check the main request (no suffix)
        main_pricing_options = ["pricing_tiff", "pricing_pdf", "pricing_photocopy"]
        main_selected = main_pricing_options.any? { |field|
          value = form_params[field]
          ["1", "1.0", 1, true, "true", "on"].include?(value)
        }

        unless main_selected
          Rails.logger.error "No pricing options selected for main copy request"
          return false
        end

        # Check additional requests (01-09)
        (1..9).each do |i|
          index = i.to_s.rjust(2, "0")
          # Check if this request has any data (collection_title is required)
          collection_field = "collection_title_#{index}"

          if form_params[collection_field].present?
            # This request has data, so it needs pricing options
            pricing_fields = ["pricing_tiff_#{index}", "pricing_pdf_#{index}", "pricing_photocopy_#{index}"]
            has_pricing = pricing_fields.any? { |field|
              value = form_params[field]
              ["1", "1.0", 1, true, "true", "on"].include?(value)
            }

            unless has_pricing
              Rails.logger.error "No pricing options selected for copy request #{i + 1}"
              return false
            end
          end
        end
      end

      FormSubmission.create!(
        form_type: type,
        form_attributes: form_params.except("form_type", "recipients")
      )
      true
    rescue => e
      Rails.logger.error "Failed to save form to database: #{e.message}"
      false
    end
  end
end
