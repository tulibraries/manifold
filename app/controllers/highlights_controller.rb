# frozen_string_literal: true

class HighlightsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_highlight, only: [:show]
  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    serializable_show
  end

  private
    def set_highlight
      @highlight = find_instance
      return redirect_or_404 unless @highlight
    end
end
