# frozen_string_literal: true

require "rails_helper"

RSpec.describe FuzzyFind::Event do

  before do
    @service = FuzzyFind::FinderService = double("fuzzy double")
  end
  let(:event_name) { "Party at Your House!" }
  let(:event) { described_class.find(event_name) }

  describe "#find" do
    it "passes expected default params to FuzzyFind::FinderService" do
      expect(@service).to receive(:call)
        .with(
          needle: event_name,
          haystack_model: ::Event,
          attribute: :title,
          addl_attribute: {}
        )
      event
    end
  end
end
