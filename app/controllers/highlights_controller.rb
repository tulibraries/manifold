# frozen_string_literal: true

class HighlightsController < ApplicationController
  include SetInstance
  include RedirectLogic
  include SerializableRespondTo
  before_action :set_highlight, only: [:show]

  private
    def set_highlight
      @highlight = find_instance
      return redirect_or_404 unless @highlight
    end
end
