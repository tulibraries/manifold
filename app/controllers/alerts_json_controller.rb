# frozen_string_literal: true

class AlertsJsonController < ApplicationController
  def index
    @alertsJson = AlertsJson.first
    respond_to do |format|
      format.json { render json: @alertsJson.message }
    end
  end
end
