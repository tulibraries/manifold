# frozen_string_literal: true

require "rails_helper"

RSpec.describe FindingAidsHelper, type: :helper do
  describe "If the chosen subject isn't in list of subjects" do
    it "returns no links" do
      expect(subject_links([])).to match_array([])
    end
  end
end
