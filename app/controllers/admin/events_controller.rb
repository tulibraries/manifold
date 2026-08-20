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

    # A full feed sync takes minutes -- longer than the request can live -- so it
    # runs on the queue. The index polls itself until the job reports back.
    def sync
      Rails.cache.write(SyncLibcalEventsJob::RUNNING_CACHE_KEY, true, expires_in: 30.minutes)
      SyncLibcalEventsJob.perform_later
      redirect_to admin_events_path
    end

    def index
      outcome = Rails.cache.read(SyncLibcalEventsJob::FINISHED_CACHE_KEY)

      if outcome.present?
        Rails.cache.delete(SyncLibcalEventsJob::FINISHED_CACHE_KEY)
        Rails.cache.delete(SyncLibcalEventsJob::RUNNING_CACHE_KEY)
        report_sync_outcome(outcome)
      elsif Rails.cache.read(SyncLibcalEventsJob::RUNNING_CACHE_KEY).present?
        @sync_in_progress = true
        flash.now[:notice] = "Events sync in progress. This page will update when it finishes."
      end

      super
    end

    def valid_action?(name, resource = resource_class)
      %w[new destroy].exclude?(name.to_s) && super
    end

    private

      def report_sync_outcome(outcome)
        if outcome == SyncLibcalEventsJob::FAILED
          flash.now[:error] = "Events sync failed before it finished -- see log/sync-libcal-event.log."
        else
          flash.now[:notice] = sync_message(Rails.cache.read("events_image_error"))
        end
      end

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
