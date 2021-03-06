# frozen_string_literal: true

require "rails_helper"

RSpec.describe FuzzyFind::Building do


  let(:building_name) { "Your House!" }
  let(:building) { described_class.find(building_name) }

  describe "#find" do
    it "passes expected default params to FuzzyFind::FinderService" do
      allow(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: building_name,
          haystack_model: ::Building,
          attribute: :name,
          addl_attribute: {}
        )

      expect(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: building_name,
          haystack_model: ::Building,
          attribute: :name,
          addl_attribute: {}
        )
      building
    end
  end
end
