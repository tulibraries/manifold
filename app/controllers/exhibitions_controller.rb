# frozen_string_literal: true

class ExhibitionsController < ApplicationController
  include SetInstance
  include RedirectLogic
  include SerializableRespondTo
  before_action :set_exhibition, only: [:show]

  def index
    serializable_index
  end

  def show
    serializable_show
  end

  private
    def set_exhibition
      @exhibition = find_instance
      return redirect_or_404 unless @exhibition
    end
end
