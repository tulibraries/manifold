# frozen_string_literal: true

namespace :sync do
  desc "sync events"
  task :events, [:path] => :environment do |t, args|
    args.with_defaults(path: nil)
    SyncService::Events.call(events_url: args[:path], force: true)
  end
end
