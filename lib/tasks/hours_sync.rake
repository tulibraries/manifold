# frozen_string_literal: true

namespace :sync do
  desc "sync hours"
  task :hours, [:path] => :environment do |t, args|
    SyncService::Hours.call()
  end
end
