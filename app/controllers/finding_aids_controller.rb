# frozen_string_literal: true

class FindingAidsController < ApplicationController
  before_action :set_finding_aid, only: [:show]

  def index
    @finding_aids = FindingAid.all
  end

  def show
  end

  private
    def set_finding_aid
      @finding_aid = FindingAid.find(params[:id])
    end
end
