# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncLibcalEventsJob, type: :job do
  describe "#perform" do
    it "runs the sync, records that it finished, and clears the running flag" do
      allow(SyncService::LibcalEvents).to receive(:call)
      allow(Rails.cache).to receive(:write)
      allow(Rails.cache).to receive(:delete)

      described_class.perform_now

      expect(SyncService::LibcalEvents).to have_received(:call)
      expect(Rails.cache).to have_received(:write)
        .with(described_class::FINISHED_CACHE_KEY, described_class::SUCCEEDED, hash_including(:expires_in))
      expect(Rails.cache).to have_received(:delete).with(described_class::RUNNING_CACHE_KEY)
    end

    it "records failure rather than success when the sync raises" do
      allow(SyncService::LibcalEvents).to receive(:call).and_raise(StandardError, "boom")
      allow(Rails.cache).to receive(:write)
      allow(Rails.cache).to receive(:delete)

      expect { described_class.perform_now }.to raise_error(StandardError, "boom")

      expect(Rails.cache).to have_received(:write)
        .with(described_class::FINISHED_CACHE_KEY, described_class::FAILED, hash_including(:expires_in))
      expect(Rails.cache).not_to have_received(:write)
        .with(described_class::FINISHED_CACHE_KEY, described_class::SUCCEEDED, anything)
      # Cleared regardless, so the admin page stops reloading.
      expect(Rails.cache).to have_received(:delete).with(described_class::RUNNING_CACHE_KEY)
    end
  end
end
