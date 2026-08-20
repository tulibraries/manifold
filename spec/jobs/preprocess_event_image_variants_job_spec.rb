# frozen_string_literal: true

require "rails_helper"

RSpec.describe PreprocessEventImageVariantsJob, type: :job do
  let(:event) { FactoryBot.create(:event, :with_image) }
  let(:service) { ActiveStorage::Blob.service }

  describe "#perform" do
    it "does nothing when the event has no image" do
      expect { described_class.perform_now(FactoryBot.create(:event)) }.not_to raise_error
    end

    it "stores every derivative the event templates use" do
      described_class.perform_now(event)

      keys = [event.thumb_image, event.index_image, event.show_image,
              event.custom_image(180, 180), event.fit_image(600, 600)].map(&:key)

      expect(keys).to all(be_present)
      expect(keys).to all(satisfy { |key| service.exist?(key) })
    end

    context "when a variant record exists but its derivative is gone from storage" do
      before do
        described_class.perform_now(event)
        # Delete the object behind Active Storage's back, leaving the record in
        # place — the state a failed upload or a bucket lifecycle rule produces.
        service.delete(event.reload.index_image.key)
      end

      it "would otherwise be unrecoverable, because processed? only checks the record" do
        variant = event.reload.index_image
        variant.processed

        expect(service.exist?(variant.key)).to be false
      end

      it "destroys the stale record and regenerates the derivative" do
        expect { described_class.perform_now(event.reload) }
          .to change { event.reload.index_image.key }

        expect(service.exist?(event.reload.index_image.key)).to be true
      end

      it "leaves the other derivatives alone" do
        show_key = event.reload.show_image.key

        described_class.perform_now(event.reload)

        expect(event.reload.show_image.key).to eq show_key
      end
    end

    it "logs and continues when one derivative fails" do
      allow(event).to receive(:index_image).and_raise(MiniMagick::Error, "boom")
      allow(Rails.logger).to receive(:error)

      described_class.perform_now(event)

      expect(Rails.logger).to have_received(:error).with(/index_image.*MiniMagick::Error: boom/)
      expect(service.exist?(event.show_image.key)).to be true
    end
  end
end
