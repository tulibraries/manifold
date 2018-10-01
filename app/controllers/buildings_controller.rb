class BuildingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_building, only: [:show]
  before_action :set_date, only: [:show]

  def index
    @buildings = Building.all
  end

  def show
    @todays_hours = LibraryHours.where(location_id: @building.hours, date: @today)
  end

  private
    def set_building
      @building = Building.find(params[:id])
    end

    def building_params
      params.require(:building).permit()
    end

    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end

end
