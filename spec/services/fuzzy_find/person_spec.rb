# frozen_string_literal: true

require "rails_helper"

RSpec.describe FuzzyFind::Person do


  let(:person_name) { "Your Name" }
  let(:person) { described_class.find(person_name) }

  describe "#find" do
    it "passes expected default params to FuzzyFind::FinderService" do
      allow(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: person_name,
          haystack_model: ::Person,
          attribute: :name,
          addl_attribute: {}
        )
      expect(FuzzyFind::FinderService).to receive(:call)
        .with(
          needle: person_name,
          haystack_model: ::Person,
          attribute: :name,
          addl_attribute: {}
        )
      person
    end
  end
end
