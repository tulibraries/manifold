# frozen_string_literal: true

namespace :sync do
  desc "publish today's hours for charles librasry to file"
  task todays_hours: :environment do
    SyncService::TodaysHours.call
  end
end
