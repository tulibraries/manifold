# frozen_string_literal: true

class ServicesController < ApplicationController
  load_and_authorize_resource
  before_action :set_service, only: [:show]

  def show
    @services = Service.all
    groups = @services.group_by { |service| service.service_category }
    @grouped_services = Hash[ groups.sort_by { |key, val| key } ]
    @key_group = @service.service_category
  end

  private
    def set_service
      @service = Service.find(params[:id])
    end
end
