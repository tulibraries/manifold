# frozen_string_literal: true

class ServicesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  include SerializableRespondTo

  before_action :set_service, only: [:show]

  def index
    serializable_index
  end

  def show
    serializable_show
  end

  def list_item(category)
    cat_link(category, @service)
  end
  helper_method :list_item

  private
    def set_service
      @service = find_instance
      return redirect_or_404 unless @service
      @categories = @service.categories
    end
end
