# frozen_string_literal: true

class FindingAidsController < ApplicationController
  before_action :set_finding_aid, only: [:show]

  def index
    @finding_aids = FindingAid.all
    respond_to do |format|
      format.html
      format.json { render json: FindingAidSerializer.new(@finding_aids) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: FindingAidSerializer.new(@finding_aid) }
    end
  end

  private
    def set_finding_aid
      @finding_aid = FindingAid.find(params[:id])
    end
end
