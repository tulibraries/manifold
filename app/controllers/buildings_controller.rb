# frozen_string_literal: true

class BuildingsController < ApplicationController
  include HasCategories
  load_and_authorize_resource
  before_action :set_building, only: [:show]

  def index
    @buildings = Building.all
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: BuildingSerializer.new(@buildings) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: BuildingSerializer.new(@building) }
    end
  end

  def list_item(category)
    cat_link(category, @building)
  end
  helper_method :list_item

  private
    def set_building
      @building = Building.find(params[:id])
      @categories = @building.categories
    end

    def building_params
      params.require(:building).permit()
    end
end
