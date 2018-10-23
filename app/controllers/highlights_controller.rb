# frozen_string_literal: true

class HighlightsController < ApplicationController
  before_action :set_highlight, only: [:show]

  def show
  end

  private
    def set_highlight
      @highlight = Highlight.find(params[:id])
    end
end
