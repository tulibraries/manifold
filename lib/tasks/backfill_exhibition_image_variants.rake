# frozen_string_literal: true

# One-time backfill for exhibition-image derivatives, needed because
# exhibitions began rendering derivatives with MAN-1590. Images attached
# before that have no processed variant, so page views fall back to the
# Temple T until this runs. Uses the originals already in Active Storage.
#
#   rake exhibitions:backfill_image_variants
namespace :exhibitions do
  desc "one-time: queue image derivatives for every exhibition with an attached image"
  task backfill_image_variants: :environment do
    queued = 0

    Exhibition.joins(:image_attachment).find_each do |exhibition|
      PreprocessEventImageVariantsJob.perform_later(exhibition)
      queued += 1
    end

    puts "Queued image-variant preprocessing for #{queued} exhibition(s)."
  end
end
