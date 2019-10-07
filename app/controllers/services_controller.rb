# frozen_string_literal: true

class ServicesController < ApplicationController
  include HasCategories
  include RedirectLogic

  before_action :set_service, only: [:show]
  before_action :navigation_items, only: [:show]

  def index
    @services = Service.all
    respond_to do |format|
      format.html
      format.json { render json: ServiceSerializer.new(@services) }
    end
  end

  def show
    @services = Service.all
    groups = @services.group_by { |service| service.service_category }
    @grouped_services = Hash[ groups.sort_by { |key, val| key } ]
    @key_group = @service.service_category
    respond_to do |format|
      format.html
      format.json { render json: ServiceSerializer.new(@service) }
    end
  end

  def navigation_items
    @nav_items = []
    @categories.each do |cat|
      cat.items(exclude: [:category]).sort_by { |e| e.label }.each do |item|
        unless item.id == @service.id
          @nav_items << item
        end
      end
    end
  end

  def list_item(category)
    cat_link(category, @service)
  end
  helper_method :list_item

  private
    def set_service
      @service = Service.find_by(id: params[:id])
      return redirect_or_404 unless @service
      @categories = @service.categories
    end
end
