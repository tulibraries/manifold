# frozen_string_literal: true

module Admin
  class EventsController < Admin::ApplicationController
    # [TODO] the Admin::SortByAttribute prevents database updates from the admin form
    # include Admin::SortByAttribute
    # # Override the default sort of id
    # def sort_by
    #   :start_time
    # end

    def sync
      SyncService::Events.call()
      flash[:notice] = "Events synced"
      redirect_to admin_events_path
    end
  end
end
