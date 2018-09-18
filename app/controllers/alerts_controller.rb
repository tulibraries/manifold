class AlertsController < ApplicationController
	load_and_authorize_resource
	def index
		@alerts = Alert.all
	end
	def show
		@alert = Alert.find_by(id: params[:id])
	end
end
