# frozen_string_literal: true

class ServicesController < ApplicationController
  load_and_authorize_resource
  before_action :set_service, only: [:show]

  def show
    respond_to do |format|
      format.html
      # format.json { render json: ServiceSerializer.new(@service) }
    end
  end

  private
    def set_service
      @service = Service.find(params[:id])
      @categories = @service.categories
    end
end
