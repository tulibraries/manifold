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

    # Flash is stored in the session cookie, which Rack caps at 4kb -- so only ever
    # name the first few failures and point at the log for the rest.
    LISTED_IMAGE_FAILURES = 5

    def sync
      SyncService::LibcalEvents.call
      flash[:notice] = sync_message(Rails.cache.read("events_image_error"))
      redirect_to admin_events_path
    end

    def valid_action?(name, resource = resource_class)
      %w[new destroy].exclude?(name.to_s) && super
    end

    private

      def sync_message(failed_titles)
        return "Events synced" if failed_titles.blank?

        listed = failed_titles.first(LISTED_IMAGE_FAILURES)
        remaining = failed_titles.size - listed.size
        names = listed.join(", ")
        names += ", and #{remaining} more (see log/sync-libcal-event.log)" if remaining.positive?

        "Events synced, but #{failed_titles.size} " \
          "#{'image'.pluralize(failed_titles.size)} could not be retrieved from LibCal: #{names}"
      end
  end
end
