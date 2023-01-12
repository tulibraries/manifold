# frozen_string_literal: true

class BuildingsController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  before_action :set_building, only: [:show]
  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    @covid_alert = @building.covid_alert
    serializable_show
  end

  def list_item(category)
    cat_link(category, @building)
  end
  helper_method :list_item

  private
    def set_building
      @building = find_instance
      @categories = @building.categories unless @building.nil?
      return redirect_or_404(@building)
    end

    def building_params
      params.require(:building).permit()
    end
end
