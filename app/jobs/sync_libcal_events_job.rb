# frozen_string_literal: true

class SyncLibcalEventsJob < ApplicationJob
  queue_as :default

  RUNNING_CACHE_KEY = "events_sync_running"
  FINISHED_CACHE_KEY = "events_sync_finished"

  SUCCEEDED = "succeeded"
  FAILED = "failed"

  def perform
    SyncService::LibcalEvents.call
    Rails.cache.write(FINISHED_CACHE_KEY, SUCCEEDED, expires_in: 1.day)
  rescue StandardError
    # read_events raises outside the per-event rescue, so bad credentials or an
    # unreachable LibCal abort the whole run -- the page must not report success.
    Rails.cache.write(FINISHED_CACHE_KEY, FAILED, expires_in: 1.day)
    raise
  ensure
    Rails.cache.delete(RUNNING_CACHE_KEY)
  end
end
