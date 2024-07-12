# frozen_string_literal: true

class BuildingsController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  include SerializableRespondTo
  before_action :set_building, only: [:show]

  def index
    serializable_index
  end

  def show
    @header_alert = @building.covid_alert
    @model = @building
    serializable_show
    if @building.hours.present?
      hours = Google::SheetsConnector.call(feature: "hours", scope: @building.hours)
      if hours.present?
        @weekly_hours = Google::WeeklyHours.new(hours: hours, location: @building)
      else
        @weekly_hours = ""
      end
    end
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

    def permitted_attributes
      super + [:publish]
    end
end
