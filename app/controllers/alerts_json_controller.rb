# frozen_string_literal: true

class AlertsJsonController < ApplicationController
  def show
    @alertsJson = AlertsJson.first
    respond_to do |format|
      format.html { render "alerts_json/show", layout: false  }
      format.json { render json: @alertsJson.message }
    end
  end
end
