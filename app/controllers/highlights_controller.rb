# frozen_string_literal: true

class HighlightsController < ApplicationController
  include SerializableRespondTo
  def index
    serializable_index
  end
end
