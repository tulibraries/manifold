# frozen_string_literal: true

class ExhibitionsController < ApplicationController
  include SetInstance
  include RedirectLogic
  before_action :set_exhibition, only: [:show]
  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    @header_alert = @exhibition.covid_alert
    serializable_show
  end

  private
    def set_exhibition
      @exhibition = find_instance
      return redirect_or_404(@exhibition)
    end

    def permitted_attributes
      super + [:draft_description, :publish]
    end
end
