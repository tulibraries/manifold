# frozen_string_literal: true

module Admin
  class ServicesController < Admin::ApplicationController
    def create
      service_params = params[:service]
      service_params.permit!
      service = Service.new(service_params)

      if service.save
        redirect_to(
          [namespace, service],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, service),
        }
      end
    end

    def update
      service = Service.find(params[:id])
      service_params = params[:service]
      service_params.permit!
      if service.update(service_params)
        redirect_to(
          [namespace, service],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, service),
        }
      end
    end
  end
end
