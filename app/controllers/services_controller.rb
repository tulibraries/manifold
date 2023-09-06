# frozen_string_literal: true

class ServicesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic

  before_action :set_service, only: [:show]

  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    @header_alert = @service.covid_alert
    serializable_show
  end

  def list_item(category)
    cat_link(category, @service)
  end
  helper_method :list_item

  private
    def set_service
      @service = find_instance
      @categories = @service.categories unless @service.nil?
      return redirect_or_404(@service)
    end

    def permitted_attributes
      super + [:draft_description, :draft_access_description, :publish]
    end
end
