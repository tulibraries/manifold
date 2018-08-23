require "rails_helper"

RSpec.describe BaseDashboard do #, type: :controller do
  describe "#tinymce?" do
    it "returns the default value" do
      expect(described_class.new.tinymce?).to be false
    end
  end
end
