# frozen_string_literal: true

class HighlightsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_highlight, only: [:show]

  def index
    @highlights = Highlight.all
    respond_to do |format|
      format.html
      format.json { render json: HighlightSerializer.new(@highlights) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: HighlightSerializer.new(@highlight) }
    end
  end

  private
    def set_highlight
      @highlight = find_instance
      return redirect_or_404 unless @highlight
    end
end
