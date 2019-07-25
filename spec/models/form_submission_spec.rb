# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormSubmission, type: :model do
  let(:fs) { FactoryBot.create(:form_submission) }

  describe "form_attributes" do
    it "returns the data decrypted" do
      expect(fs.form_attributes).to include(
        "attribute1" => "value 1",
        "attribute2" => "value 2"
      )
    end
  end
end
