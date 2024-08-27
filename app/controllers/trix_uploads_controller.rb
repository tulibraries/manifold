# frozen_string_literal: true

# app/controllers/files_controller.rb
class TrixUploadsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    file_content = params["blob"]
    file_name = params[:file_name] || "default.txt"
    file_path = Rails.root.join("public", file_name)

    File.open(file_path, "w") do |file|
      file.write(file_content)
    end

  rescue => e
    render json: { status: "Error", message: e.message }, status: :unprocessable_entity
  end
end
