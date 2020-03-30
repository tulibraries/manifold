# frozen_string_literal: true

class HighlightsController < ApplicationController
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
      if Highlight.find_by(slug: params[:id])
        @highlight = Highlight.friendly.find(params[:id])
      else
        @highlight = Highlight.find_by(id: params[:id])
      end
      return redirect_or_404 unless @highlight
    end
end
