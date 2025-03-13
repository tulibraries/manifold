# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  def index
    begin
      hours = Google::SheetsConnector.call(feature: "hours")
      if hours.present?
        render(Google::HoursComponent.new(hours:, date: params[:date]))
      else
        redirect_to(root_path, notice: "The requested page is not available")
      end
    rescue
      redirect_to(root_path, notice: "The requested page is not available. Try again later.")
    end
  end
end
