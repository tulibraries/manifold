# frozen_string_literal: true

class FormsController < ApplicationController
  def index
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

    if @form.deliver
      persist_form!
      redirect_to forms_path(success: "true")
    else
      redirect_to forms_path(success: "false")
    end
  end

  def persist_form!
    type = params[:form].delete(:form_type)
    recipients = params[:form].delete(:recipients)
    FormSubmission.create(
      form_type: type,
      form_attributes: params["form"].except(:recipients)
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
end
