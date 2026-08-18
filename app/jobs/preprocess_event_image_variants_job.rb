# frozen_string_literal: true

# Generates the event image derivatives up front, during the LibCal sync, so the
# first visitor to a page does not pay for the transformation.
#
# It also repairs derivatives whose bookkeeping and storage disagree. With
# +ActiveStorage.track_variants+ enabled, ActiveStorage::VariantWithRecord#processed?
# is just `record.present?` — it never asks the service whether the derivative is
# actually there. So a derivative whose object is missing from the bucket (an
# upload that failed after the row was committed, a lifecycle rule that expired
# the object) is considered done forever, and every request for it 404s with no
# way to recover. Verifying against the service and dropping the stale record is
# what lets it regenerate.
class PreprocessEventImageVariantsJob < ApplicationJob
  queue_as :default

  # Derivatives used by the event index, show, and search result templates,
  # as [method, *args] pairs so a variant can be rebuilt from scratch after a
  # stale record is destroyed.
  DERIVATIVES = [
    [:thumb_image],
    [:index_image],
    [:show_image],
    [:custom_image, 180, 180],
    [:fit_image, 600, 600]
  ].freeze

  VARIANT_CLASSES = [ActiveStorage::Variant, ActiveStorage::VariantWithRecord].freeze

  def perform(event)
    return unless event.image.attached?

    DERIVATIVES.each { |method, *args| ensure_derivative(event, method, args) }
  end

  private

    def ensure_derivative(event, method, args)
      variant = build_variant(event, method, args)
      return if variant.nil?

      variant.processed
      return if stored?(variant)

      variant.destroy
      # The destroyed record is memoized on the old variant object, so rebuild
      # from the model to get one that will actually process.
      rebuilt = build_variant(event, method, args)
      rebuilt&.processed
    rescue StandardError => e
      Rails.logger.error(
        "PreprocessEventImageVariantsJob: #{method}(#{args.join(', ')}) failed for " \
        "event #{event.id} / blob #{event.image.blob&.id}: #{e.class}: #{e.message}"
      )
    end

    # Imageable#custom_image and #fit_image return the attachment itself when the
    # original already matches the requested dimensions; there is nothing to
    # process in that case.
    def build_variant(event, method, args)
      variant = event.public_send(method, *args)
      variant if VARIANT_CLASSES.any? { |klass| variant.is_a?(klass) }
    end

    def stored?(variant)
      key = variant.key
      key.present? && variant.service.exist?(key)
    end
end
