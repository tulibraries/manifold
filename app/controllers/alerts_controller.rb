# frozen_string_literal: true

class AlertsController < ApplicationController
  include SerializableRespondTo

  def index
    serializable_index
  end
  def show
    @alert = Alert.find(params[:id])
  end
end
