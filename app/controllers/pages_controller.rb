# frozen_string_literal: true

class PagesController < ApplicationController

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end

  def home
  end

  def ambler
  end
end
