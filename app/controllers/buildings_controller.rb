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
    serializable_show
    @covid_alert = @building.covid_alert
  end

  def list_item(category)
    cat_link(category, @building)
  end
  helper_method :list_item

  private
    def set_building
      @building = find_instance
      @categories = @building.categories
      return redirect_or_404(@building)
    end

    def building_params
      params.require(:building).permit()
    end
end
