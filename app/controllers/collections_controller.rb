# frozen_string_literal: true

class CollectionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_collection, only: [:show, :finding_aids]
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

  def finding_aids
  end

  private
    def set_collection
      @collection = Collection.find(params[:id])
    end
end
