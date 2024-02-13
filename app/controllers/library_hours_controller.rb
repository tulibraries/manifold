# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  def index
    hours = Google::SheetsConnector.call(feature: "hours")
    if hours.present?
      render(Google::HoursComponent.new(hours:, date: params[:date]))
    else
      redirect_to(root_path, notice: "The requested page is not available")
    end
  end

  def charles_today
    today = Google::SheetsConnector.call(feature: "hours", scope: "today")
    hours = Google::SheetsConnector.call(feature: "hours", scope: "charles")
    binding.pry
    # start_at(time.values.first)
    # if hours.present?
    #   render(Google::HoursComponent.new(hours:, date: params[:date]))
    # else
    #   redirect_to(root_path, notice: "The requested page is not available")
    # end
  end

  def start_at(rows)
    rows.index{|d| d[0] == @today.strftime("%A, %B %-d, %Y")}
  end
end 