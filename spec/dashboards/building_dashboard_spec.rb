# frozen_string_literal: true

require "rails_helper"

RSpec.describe BuildingDashboard do
  describe "#tinymce?" do
    skip
    it "returns the local override value" do
      expect(BuildingDashboard.new.tinymce?).to be true
    end
  end
end
