# frozen_string_literal: true

class FormsController < ApplicationController
  # def new
  #   @form = Form.new
  #   render template: "forms/#{params[:type]}"
  # end
  def new
    @form = Form.new
    @type = params[:type]
    render template: "forms/index"
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

  def form_objects_for_json
    forms = Dir.glob("#{Rails.root.join('app/views/forms/*/')}")
      .map { |template_path| template_path.split("/").last }
      .reject { |template_name| template_name == "shared" }
      .map do |form|
        OpenStruct.new(
          id: form,
          label: t("manifold.default.forms.#{form.underscore}.title"),
          link: "#{request.base_url}/forms/#{form}",
          updated_at: DateTime.new(0)
        )
      end
  end

  def create
    @form = Form.new(params[:form])
    @form.request = request

    if @form.deliver
      flash.now[:notice] = "Thank you for your message. We will contact you soon!"
    else
      flash.now[:error] = "Cannot send message."
      render :new
    end
  end
end
