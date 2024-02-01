# frozen_string_literal: true

class LibraryHoursController < ApplicationController
  def index
    hours = Google::SheetsConnector.call(feature: "hours")
    # if etexts.present?
    #   render(Google::EtextbooksComponent.new(etexts:, title: snippet[:title],
    #                                                   description: snippet[:description],
    #                                                   column: params[:column],
    #                                                   direction: params[:direction]))
    # else
    #   redirect_to(root_path, notice: "The requested page is not available")
    # end
  end

end 