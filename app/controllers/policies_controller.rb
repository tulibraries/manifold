# frozen_string_literal: true

class PoliciesController < ApplicationController
  load_and_authorize_resource
  before_action :set_policy, only: [:show]

  # GET /policies
  # GET /policies.json
  def index
    @policies = Policy.all
  end

  # GET /policies/1
  # GET /policies/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_policy
      @policy = Policy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def policy_params
      params.require(:policy).permit(:name, :description, :effective_date, :expiration_date)
    end
end
