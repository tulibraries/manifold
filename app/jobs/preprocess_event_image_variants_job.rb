# frozen_string_literal: true

# Generates the event image derivatives up front, during the LibCal sync, so the
# first visitor to a page does not pay for the transformation.

class PreprocessEventImageVariantsJob < ApplicationJob
  queue_as :default

  DERIVATIVES = [
    [:thumb_image],
    [:index_image],
    [:show_image],
    [:featured_image],
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
      rebuilt = build_variant(event, method, args)
      rebuilt&.processed
    rescue StandardError => e
      Rails.logger.error(
        "PreprocessEventImageVariantsJob: #{method}(#{args.join(', ')}) failed for " \
        "event #{event.id} / blob #{event.image.blob&.id}: #{e.class}: #{e.message}"
      )
    end

    def build_variant(event, method, args)
      variant = event.public_send(method, *args)
      variant if VARIANT_CLASSES.any? { |klass| variant.is_a?(klass) }
    end

    def stored?(variant)
      key = variant.key
      key.present? && variant.service.exist?(key)
    end
end
