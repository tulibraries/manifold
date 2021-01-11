# frozen_string_literal: true

class SpacesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  before_action :set_space, only: [:show]
  include SerializableRespondTo

  def index
    @spaces = Space.all
    respond_to do |format|
      format.html { render "errors/not_found", status: :not_found }
      format.json { render json: SpaceSerializer.new(@spaces) }
    end
  end

  # GET /spaces/1
  # GET /spaces/1.json
  def show
    @covid_alert = @space.covid_alert
    @categories = @space.categories
    serializable_show
  end

  def list_item(category)
    cat_link(category, @space)
  end
  helper_method :list_item

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_space
      @space = find_instance
      return redirect_or_404(@space)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def space_params
      params.require(:space).permit()
    end
end
