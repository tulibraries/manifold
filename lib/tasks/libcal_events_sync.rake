# frozen_string_literal: true

namespace :sync do
  desc "sync LibCal events"
  task :libcal_events, [:ids] => :environment do |_t, args|
    args.with_defaults(ids: nil)
    SyncService::LibcalEvents.call(event_ids: args[:ids], force: true)
  end
end
