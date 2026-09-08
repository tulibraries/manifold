# frozen_string_literal: true

require "spec_helper"

# Models including EventImageable pad their event-list images to 5:3 rather
# than cropping them. Gallery attachments (images) are not affected.
RSpec.shared_examples "event imageable" do
  let(:event_record) { FactoryBot.create(described_class.to_s.underscore.to_sym, :with_image) }

  {
    thumb_image: [160, 96],
    index_image: [360, 216],
    show_image: [420, 252],
  }.each do |method, (width, height)|
    it "pads #{method} to #{width}x#{height}" do
      expect(event_record.image).to receive(:variant).with(
        format: :png,
        background: :transparent,
        gravity: "Center",
        resize_to_fit: [width, height],
        extent: "#{width}x#{height}"
      )

      event_record.public_send(method)
    end
  end
end
