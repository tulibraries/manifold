# frozen_string_literal: true

class BuildingsController < ApplicationController
  include HasCategories
  load_and_authorize_resource
  before_action :set_building, only: [:show]
  before_action :set_date, only: [:show]
  before_action :navigation_items, only: [:show]

  def index
    @buildings = Building.all
    respond_to do |format|
      format.html
      format.json { render json: BuildingSerializer.new(@buildings) }
    end
  end

  def show
    @todays_hours = LibraryHour.where(location_id: @building.hours, date: @today)
    respond_to do |format|
      format.html
      format.json { render json: BuildingSerializer.new(@building) }
    end
  end

  def navigation_items
    @nav_items = []
    @categories.each do |cat|
      cat.items(exclude: [:category]).each do |item|
        unless item.id == @building.id
          @nav_items << item
        end
      end
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

    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end
end
