# frozen_string_literal: true

class FindingAidsController < ApplicationController
  include SetInstance
  include RedirectLogic

  before_action :set_finding_aid, only: [:show]
  before_action :return_aids, only: [:index]
  include SerializableRespondTo

  def index
    respond_to do |format|
      format.html
      format.json { render json: FindingAidSerializer.new(@finding_aids) }
    end
  end

  def show
    serializable_show
  end

  def return_aids
    @finding_aids = FindingAid
      .includes(:collections)
      .with_subject(subjects)
      .in_collection(collection)
      .order(:name)

    @subjects = get_subject_filter_values(@finding_aids)
    @collections = get_collection_filter_values(@finding_aids)
    @aids_list = @finding_aids.page params[:page]
  end

  def get_subject_filter_values(finding_aids)
    finding_aids
      .map(&:subject)
      .flatten
      .sort
      .uniq
  end

  def get_collection_filter_values(finding_aids)
    finding_aids
      .map(&:collections)
      .flatten
      .sort
      .uniq
  end

  def subjects
    params.fetch("subject", "").split(",") if params[:subject].present?
  end

  def collection
    params["collection"]
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
