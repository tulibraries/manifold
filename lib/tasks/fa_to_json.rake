# frozen_string_literal: true

namespace :sync do
  desc "publish finding aids as json to assets file"
  task fas: :environment do
    SyncService::FaToJson.call
  end
end
