# frozen_string_literal: true

class ExhibitionsController < ApplicationController
  before_action :set_exhibition, only: [:show]

  def index
    @exhibitions = Exhibition.all
    respond_to do |format|
      format.html
      format.json { render json: ExhibitionSerializer.new(@exhibitions) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: ExhibitionSerializer.new(@exhibition) }
    end
  end

  private
    def set_exhibition
      @exhibition = Exhibition.friendly.find(params[:id])
    end
end
