# frozen_string_literal: true

namespace :sync do
  desc "sync events"
  task :hours => :environment do
    SyncService::LibraryHours.call
  end
end
