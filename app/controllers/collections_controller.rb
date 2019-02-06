# frozen_string_literal: true

class CollectionsController < ApplicationController
  load_and_authorize_resource
  before_action :set_collection, only: [:show, :finding_aids]
  def index
    @collections = Collection.all
  end

  def show
  end

  def finding_aids
  end

  private
    def set_collection
      @collection = Collection.find(params[:id])
    end
end
