# frozen_string_literal: true

class CategoriesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  before_action :set_category, only: [:show]
  include SerializableRespondTo

  def show
    @covid_alert = @category.covid_alert
    respond_to do |format|
      format.html {
        @nav_items = []
        @category.items.each do |item|
          @nav_items << item
        end
      }
      format.json {
        serializable_show
      }
    end

    if @category.slug == "explore-charles"
      @images = []
      11.times do |i|
        @images << (i.to_s + ".jpg")
      end
      @captions = []
      @captions << "1st floor floorplan"
      @captions << "2nd floor floorplan"
      @captions << "3rd floor floorplan"
      @captions << "4th floor floorplan"
      @captions << ""
      @captions << ""
      @captions << ""
      @captions << ""
      @captions << ""
      @captions << ""
      @captions << ""
    end
  end

  def index
    serializable_index
  end

  private
    def set_category
      @category = find_instance
      return redirect_or_404(@category)
    end

    attr_reader :long_description
end
