require "rails_helper"

describe BuildingDashboard do
  describe "#tinymce?" do
    it "returns the local override value" do
      expect(BuildingDashboard.new.tinymce?).to be true
    end
  end
end
