# frozen_string_literal: true

class CollectionsController < ApplicationController
  include HasCategories
  include RedirectLogic

  before_action :set_collection, only: [:show]

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

  def list_item(category)
    cat_link(category, @collection)
  end
  helper_method :list_item

  private
    def set_collection
      @collection = Collection.find(params[:id])
      return redirect_or_404 unless @collection
      @categories = @collection.categories
    end
end
