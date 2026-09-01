# frozen_string_literal: true

# One-time backfill for event-image derivatives after the event card dimensions
# changed. This uses the originals already in Active Storage; it does not call
# LibCal or download images again.
#
#   rake events:backfill_image_variants
namespace :events do
  desc "one-time: queue 5:3 image derivatives for every event with an attached image"
  task backfill_image_variants: :environment do
    queued = 0

    Event.joins(:image_attachment).find_each do |event|
      PreprocessEventImageVariantsJob.perform_later(event)
      queued += 1
    end

    puts "Queued image-variant preprocessing for #{queued} event(s)."
  end
end
