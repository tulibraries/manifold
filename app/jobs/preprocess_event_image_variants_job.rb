# frozen_string_literal: true

class PreprocessEventImageVariantsJob < ApplicationJob
  queue_as :default

  def perform(event)
    return unless event.image.attached?

    process_variant(event.thumb_image)
    process_variant(event.index_image)
    process_variant(event.show_image)
    process_variant(event.custom_image(180, 180))
    process_variant(event.fit_image(600, 600))
  end

  private

    def process_variant(image_or_variant)
      image_or_variant.processed if image_or_variant.respond_to?(:processed)
    end
end
