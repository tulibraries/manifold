# frozen_string_literal: true

class BuildingsController < ApplicationController
  include HasCategories
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
      if Buidling.find_by(slug: params[:id])
        @building = Buidling.friendly.find(params[:id])
      else
        @building = Buidling.find_by(id: params[:id])
      end
      return redirect_or_404 unless @building
      @categories = @building.categories
    end

    def building_params
      params.require(:building).permit()
    end
end
