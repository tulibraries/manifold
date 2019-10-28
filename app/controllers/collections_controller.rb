# frozen_string_literal: true

class CollectionsController < ApplicationController
  include HasCategories
  include RedirectLogic

  before_action :set_collection, only: [:show]
  before_action :navigation_items, only: [:show]

  def index
    @collections = Collection.all
    respond_to do |format|
      format.html
      format.json { render json: CollectionSerializer.new(@collections) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: CollectionSerializer.new(@collection) }
    end
  end

  def navigation_items
    @nav_items = []
    @categories.each do |cat|
      cat.items.each do |item|
        unless item.id == @collection.id
          @nav_items << item
        end
      end
    end
  end

  def list_item(category)
    cat_link(category, @collection)
  end
  helper_method :list_item

  private
    def set_collection
      @collection = Collection.friendly.find(params[:id])
      return redirect_or_404 unless @collection
      @categories = @collection.categories
    end
end
