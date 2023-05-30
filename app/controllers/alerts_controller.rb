# frozen_string_literal: true

class AlertsController < ApplicationController
  def index
    respond_to do |format|
      format.json { render "alerts_json/index" }
    end
  end
  def show
    @alert = Alert.find(params[:id])
  end
end
