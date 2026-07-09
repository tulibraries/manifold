# frozen_string_literal: true

module Admin
  class EventsController < Admin::ApplicationController
    include Admin::Detachable

    def order
      @order ||= Administrate::Order.new(
        params.fetch(resource_name, {}).fetch(:order, "start_time"),
        params.fetch(resource_name, {}).fetch(:direction, "desc"),
      )
    end

    def sync
      SyncService::LibcalEvents.call
      @message = Rails.cache.read("events_image_error")
      flash[:notice] = @message ? @message : "Events synced"
      redirect_to admin_events_path
    end

    def valid_action?(name, resource = resource_class)
      %w[new destroy].exclude?(name.to_s) && super
    end
  end
end
