# frozen_string_literal: true

class FileUploadsController < ApplicationController
  # Allow public access to downloads and avoid user lookups on this action
  skip_before_action :authenticate_account!, only: :show, raise: false
  skip_before_action :set_paper_trail_whodunnit, only: :show

  def show
    file_upload = FileUpload.friendly.find(params[:id])

    if file_upload.file.attached?
      disposition = params[:inline].present? ? "inline" : "attachment"
      redirect_to rails_blob_path(file_upload.file, disposition:)
    else
      head :not_found
    end
  end
end
