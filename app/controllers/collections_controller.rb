# frozen_string_literal: true

class CollectionsController < ApplicationController
  load_and_authorize_resource
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

  private
    def set_collection
      @collection = Collection.find(params[:id])
      @categories = @collection.categories
    end
end
