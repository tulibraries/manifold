# frozen_string_literal: true

class FormsController < ApplicationController
  before_action :use_unsafe_params, only: [:persist_form!]
  def index
    form_groups = FormInfo.for_index.group_by(&:grouping)
    # Remove 'No Grouping' from form_groups
    form_groups.delete("No Grouping")
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
    info = FormInfo.find_by(slug: form_type)
    @form.recipients = info.recipients.reject(&:empty?).to_json if info.present?

    email_sent = @form.deliver
    persist_form!

    if form_type == "av-requests" || form_type == "copy-requests"
      if email_sent
        redirect_to form_path(form_type, success: form_type)
      else
        redirect_to form_path(form_type, success: "false")
      end
    else
      if email_sent
        redirect_to forms_path(success: "true")
      else
        redirect_to forms_path(success: "false")
      end
    end
  end

  def persist_form!
    type = params[:form].delete(:form_type)
    params[:form].delete(:recipients) # Remove recipients from params before storing
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
end
