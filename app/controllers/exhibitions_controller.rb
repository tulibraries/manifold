# frozen_string_literal: true

class ExhibitionsController < ApplicationController
  before_action :set_exhibition, only: [:show]

  def index
    @exhibitions = Exhibition.all
  end

  def show
  end

  private
    def set_exhibition
      @exhibition = Exhibition.find(params[:id])
    end
end
