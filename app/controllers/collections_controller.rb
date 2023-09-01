# frozen_string_literal: true

class CollectionsController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic

  before_action :set_collection, only: [:show]

  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    @header_alert = @collection.covid_alert
    serializable_show
  end

  def list_item(category)
    cat_link(category, @collection)
  end
  helper_method :list_item

  private
    def set_collection
      @collection = find_instance
      @categories = @collection.categories unless @collection.nil?
      return redirect_or_404(@collection)
    end

    def permitted_attributes
      super + [:draft_description, :publish]
    end
end
