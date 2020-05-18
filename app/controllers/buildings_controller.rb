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
  end

  def list_item(category)
    cat_link(category, @building)
  end
  helper_method :list_item

  private
    def set_building
      @building = find_instance
      return redirect_or_404 unless @building
      @categories = @building.categories
    end

    def building_params
      params.require(:building).permit()
    end
end
