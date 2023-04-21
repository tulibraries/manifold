# frozen_string_literal: true

class FindingAidsController < ApplicationController
  include SetInstance
  include RedirectLogic

  before_action :set_finding_aid, only: [:show]
  before_action :return_aids, only: [:index]
  include SerializableRespondTo

  def index
  end

  def show
    @header_alert = @finding_aid.covid_alert
    serializable_show
  end

  def return_aids
    query = params[:search]
    if query.present?
      @finding_aids = FindingAid.search(query)
    else
      @finding_aids = FindingAid
      .includes(:collections)
      .with_subject(subjects)
      .in_collection(collection)
      .order(:name)
    end
    @subjects = get_subject_filter_values(@finding_aids) if query.blank?
    @collections = get_collection_filter_values(@finding_aids) if query.blank?
    @aids_list = @finding_aids.page params[:page]
  end

  def get_subject_filter_values(finding_aids)
    finding_aids
      .has_subjects
      .map(&:subject)
      .flatten
      .sort
      .uniq
  end

  def get_collection_filter_values(finding_aids)
    finding_aids
      .has_collections
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
