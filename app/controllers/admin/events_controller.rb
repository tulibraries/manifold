# frozen_string_literal: true

module Admin
  class EventsController < Admin::ApplicationController
    include Admin::SortByAttribute
    # Override the default sort of id
    def sort_by
      :start_time
    end

    def sync
      SyncService::Events.call()
      flash[:notice] = "Events synced"
      redirect_to admin_events_path
    end

    def revert
      event = Event.find(params[:event_id])
      version = event.versions.find(params[:version_id])
      version.reify.save!
      redirect_to action: :show, id: event.id
    end

  private

    # Workaround that prevents updating event objects
    def default_params
      resource_params = params.fetch(resource_name, {})
      order = resource_params.fetch(:order, "start_time")
      direction = resource_params.fetch(:direction, "asc")
      params[resource_name] = resource_params.merge(order: order, direction: direction)
    end
  end
end
