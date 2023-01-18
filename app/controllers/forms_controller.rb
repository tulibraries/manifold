# frozen_string_literal: true

class FormsController < ApplicationController
  def show
    new
  end

  def new
    @form = Form.new
    @collection = Rails.configuration.affiliation
    if existing_forms.include? params[:id]
      @type = params[:id]
      render template: "forms/index"
    else
      render "errors/not_found", status: :not_found
    end
  end

  def index
    respond_to do |format|
      format.html { render template: "forms/index" }
      format.json do
        @forms = form_objects_for_json
        render json: FormSerializer.new(@forms)
      end
    end
  end

  def all
    respond_to do |format|
      format.html { render template: "forms/index" }
      format.json do
        @forms = form_objects_for_json
        render json: FormSerializer.new(@forms)
      end
    end
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

  def create
    @form = Form.new(params[:form])
    @form.request = request
    @collection = Rails.configuration.affiliation

    if @form.deliver
      persist_form!
      redirect_to forms_path(success: "true")
    else
      redirect_to forms_path(success: "false")
    end
  end

  def persist_form!
    type = params[:form].delete(:form_type)
    FormSubmission.create(
      form_type: type,
      form_attributes: params["form"]
    )
  end
end
