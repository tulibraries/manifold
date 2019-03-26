# frozen_string_literal: true

class SpacesController < ApplicationController
  load_and_authorize_resource
  before_action :set_space, only: [:show]
  before_action :set_date, only: [:show]

  # GET /spaces
  # GET /spaces.json
  def index
    @spaces = Space.all
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
    @todays_hours = LibraryHour.where(location_id: @space.hours, date: @today)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = Space.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_params
      params.require(:space).permit()
    end

    def set_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    end
end
