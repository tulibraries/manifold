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
      if Collection.find_by(slug: params[:id])
        @collection = Collection.friendly.find(params[:id])
      else
        @collection = Collection.find_by(id: params[:id])
      end
      return redirect_or_404 unless @collection
      @categories = @collection.categories
    end
end
