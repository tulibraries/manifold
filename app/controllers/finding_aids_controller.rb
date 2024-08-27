# frozen_string_literal: true

class FindingAidsController < ApplicationController
  include SetInstance
  include RedirectLogic

  before_action :set_finding_aid, only: [:show]
  include SerializableRespondTo

  def index
    intro = Snippet.find_by(slug: "finding-aids-intro")
    @finding_aids_intro = intro.presence ? intro.description : ""
  end

  def show
    @header_alert = @finding_aid.covid_alert
    serializable_show
  end

  def search
  end


  private
    def set_finding_aid
      @finding_aid = find_instance
      unless @finding_aid.nil?
        @title = @finding_aid.label
        blockson = Collection.find_by(slug: "blockson_collection")
        @aeon = @finding_aid.collections.include?(blockson)
      end
      return redirect_or_404 (@finding_aid)
    end
end
