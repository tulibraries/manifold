# frozen_string_literal: true

class FindingAidsController < ApplicationController
  include FindingAidFilters

  before_action :set_finding_aid, only: [:show]
  before_action :return_aids, only: [:index]

  def index
    @finding_aids = FindingAid.all
    @catalog_search = "#{Rails.configuration.librarysearch_finding_aids_url}"

    respond_to do |format|
      format.html
      format.json { render json: FindingAidSerializer.new(@finding_aids) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: FindingAidSerializer.new(@finding_aid) }
    end
  end

  def return_aids
    all_aids = FindingAid.group(:id).order(:name)

    if params.has_key?("collection")
      collections = collections_list(all_aids)
    end
    if params.has_key?("subject")
      subjects = subjects_list(all_aids)
    end

    arrays = [Array(collections), Array(subjects)].reject(&:empty?).reduce(:&) || []

    filtered_aids = arrays.presence || all_aids

    get_filters(filtered_aids)
    aids = FindingAid.where(id: filtered_aids.map(&:id)).order(:name)
    @aids_list = aids.page params[:page]
  end

  def get_filters(aids)
    @subjects = aids.select { |aid| aid.subject.try(:any?) }.collect { |s| s.subject }.flatten.uniq.sort
    @collections = aids.select { |aid| aid.collections.try(:any?) }.collect { |c| c.collections }.flatten.uniq.sort
  end


  private
    def set_finding_aid
      if FindingAid.find_by(slug: params[:id])
        @finding_aid = FindingAid.friendly.find(params[:id])
      else
        @finding_aid = FindingAid.find_by(id: params[:id])
      end
      return redirect_or_404 unless @finding_aid
      @title = @finding_aid.label
      blockson = Collection.find_by(slug: "blockson_collection")
      @aeon = @finding_aid.collections.include?(blockson)
    end
end
