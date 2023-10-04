# frozen_string_literal: true

class GroupsController < ApplicationController
  # GET /groups
  # GET /groups.json
  def index
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
end
