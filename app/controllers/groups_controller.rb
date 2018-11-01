# frozen_string_literal: true

class GroupsController < ApplicationController
  load_and_authorize_resource
  before_action :set_group, only: [:show]

  # GET /groups
  # GET /groups.json
  def index
    @departments = Group.where(group_type: "Department")
    @teams = Group.where.not(group_type: "Department")
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit()
    end
end
