# frozen_string_literal: true

class GroupsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_group, only: [:show]

  # GET /groups
  # GET /groups.json
  def index
    @departments = Group.where(group_type: "Department").order(:name)
    @teams = Group.where.not(group_type: "Department").order(:name)
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = find_instance
      return redirect_or_404(@group)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit()
    end
end
