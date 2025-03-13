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

  def show
    @header_alert = @space.covid_alert
    @categories = @space.categories
    @model = @space
    @weekly_hours = ""
    serializable_show
    if @space.hours.present?
      begin
        hours = Google::SheetsConnector.call(feature: "hours", scope: @space.hours)
        @weekly_hours = Google::WeeklyHours.new(hours:, location: @space) if hours.present?
      rescue
        @weekly_hours == ""
      end
    end
  end

  def list_item(category)
    cat_link(category, @space)
  end
  helper_method :list_item

  private
    def set_space
      @space = find_instance
      return redirect_or_404(@space)
    end
end
