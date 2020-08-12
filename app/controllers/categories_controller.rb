# frozen_string_literal: true

class CategoriesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  before_action :set_category, only: [:show]
  include SerializableRespondTo

  def show
    respond_to do |format|
      format.html {
        @nav_items = []
        @category.items.each do |item|
          @nav_items << item
        end
      }
    end

    if @category.slug == "explore-charles"

      @images = []
      4.times do |i|
        @images << (i.to_s + ".jpg")
      end
      @captions = []
      @captions << "1st floor floorplan"
      @captions << "2nd floor floorplan"
      @captions << "3rd floor floorplan"
      @captions << "4th floor floorplan"
    end
  end

  def index
    serializable_index
  end

  private
    def set_category
      @category = find_instance
      return redirect_or_404 unless @category
    end
end
