# frozen_string_literal: true

require "rails_helper"

RSpec.describe FuzzyFind::Space do

  let(:space_name) { "Your Kitchen" }
  let(:space) { described_class.find(space_name) }

  describe "#find" do
    it "passes expected default params to FuzzyFind::FinderService" do
      allow(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: space_name,
          haystack_model: ::Space,
          attribute: :name,
          addl_attribute: {}
        )
      expect(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: space_name,
          haystack_model: ::Space,
          attribute: :name,
          addl_attribute: {}
        )
      space
    end
  end
end
