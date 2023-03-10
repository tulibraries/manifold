# frozen_string_literal: true

require "rails_helper"

RSpec.describe FileUpload, type: :model do
  describe "Validations" do
    file_upload = FactoryBot.create(:file_upload)

    example "Name is a string" do
      expect(file_upload.name).to be
    end

    example "Check file type is valid and not empty" do
      expect(file_upload.file.content_type).to eq "application/pdf"
    end
  end

  it_behaves_like "imageable"
end
