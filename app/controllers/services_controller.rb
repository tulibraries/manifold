# frozen_string_literal: true

class ServicesController < ApplicationController
  include HasCategories
  include RedirectLogic

  before_action :set_service, only: [:show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: ServiceSerializer.new(Service.all) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: ServiceSerializer.new(@service) }
    end
  end


  private
    def set_service
      @service = Service.find_by(id: params[:id])
      return redirect_or_404 unless @service
    end
end
