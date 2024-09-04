# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  def index
    begin
      hours = Google::SheetsConnector.call(feature: "hours")
    rescue Google::Apis::ClientError
      hours = nil
    end
  
    if hours.present?
      render(Google::HoursComponent.new(hours:, date: params[:date]))
    else
      redirect_to(root_path, notice: "The requested page is not available")
    end
  end
end
