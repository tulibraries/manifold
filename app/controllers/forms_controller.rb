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
    render template: "forms/index"
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
