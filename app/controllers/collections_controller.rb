# frozen_string_literal: true

class CollectionsController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  include SerializableRespondTo

  before_action :set_collection, only: [:show]

  def index
    serializable_index
  end

  def show
    serializable_show
  end

  def list_item(category)
    cat_link(category, @collection)
  end
  helper_method :list_item

  private
    def set_collection
      @collection = find_instance
      return redirect_or_404 unless @collection
      @categories = @collection.categories
    end
end
