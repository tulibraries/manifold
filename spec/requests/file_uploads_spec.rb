# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FileUploads", type: :request do
  let!(:file_upload) { FactoryBot.create(:file_upload, name: "SCRC Collection Policy 2025") }

  it "redirects to an attachment download by default" do
    get file_upload_path(file_upload)

    expect(response).to have_http_status(:redirect)
    expect(response.headers["Location"]).to include("disposition=attachment")
  end

  it "allows opting into inline display" do
    get file_upload_path(file_upload, inline: true)

    expect(response).to have_http_status(:redirect)
    expect(response.headers["Location"]).to include("disposition=inline")
  end

  it "skips authentication and paper trail callbacks for downloads" do
    controller = FileUploadsController.new
    if controller.respond_to?(:authenticate_account!)
      expect_any_instance_of(FileUploadsController).not_to receive(:authenticate_account!)
    end
    expect_any_instance_of(FileUploadsController).not_to receive(:set_paper_trail_whodunnit)

    get file_upload_path(file_upload)

    expect(response).to have_http_status(:redirect)
  end
end
