# frozen_string_literal: true

namespace :sync do
  desc "sync events"
  task :events, [:path] => :environment do |t, args|
    args.with_defaults(path: nil)
    sync_events = SyncService::Events.call(events_url: args[:path])
    events = sync_events.read_events
    sync_events.sync
  end
end
