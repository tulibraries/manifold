# frozen_string_literal: true

namespace :events do
  desc "sync events"
  task sync: :environment do
    sync_events = SyncEvents.new(events_url: "https://events.temple.edu/feed/xml/events?department=2566")
    events = sync_events.read_events
    sync_events.sync
  end
end
