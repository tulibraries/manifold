# frozen_string_literal: true

class SpacesController < ApplicationController
  load_and_authorize_resource
  before_action :set_space, only: [:show]
  before_action :navigation_items, only: [:show]

  def index
    @spaces = Space.all
    respond_to do |format|
      format.html { render file: "errors/not_found", status: 404 }
      format.json { render json: SpaceSerializer.new(@spaces) }
    end
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
    @categories = @space.categories
    respond_to do |format|
      format.html
      format.json { render json: SpaceSerializer.new(@space) }
    end
  end

  def navigation_items
    @nav_items = []
    @space.categories.each do |cat|
      cat.items(exclude: [:category]).sort_by { |e| e.label }.each do |item|
        unless item.id == @space.id
          @nav_items << item
        end
      end
    end
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
end
