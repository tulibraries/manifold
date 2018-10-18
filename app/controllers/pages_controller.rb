# frozen_string_literal: true

class PagesController < ApplicationController
  def home
  	# render :layout => false
  end

  def get_highlights
    @highlights = Highlight.where(promoted: true).take(4)
  end
end
