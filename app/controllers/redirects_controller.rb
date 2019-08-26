# frozen_string_literal: true

class RedirectsController < ApplicationController
  include RedirectLogic

  def show
    redirect_or_404
  end
end
