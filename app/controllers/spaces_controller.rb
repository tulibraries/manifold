# frozen_string_literal: true

class SpacesController < ApplicationController
  include HasCategories
  before_action :set_space, only: [:show]

  def index
    @spaces = Space.all
    respond_to do |format|
      format.html { render file: "errors/not_found", status: :not_found }
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

  def list_item(category)
    cat_link(category, @space)
  end
  helper_method :list_item

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
