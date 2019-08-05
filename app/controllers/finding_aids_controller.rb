# frozen_string_literal: true

class FindingAidsController < ApplicationController
  include FindingAidFilters

  before_action :set_finding_aid, only: [:show]
  before_action :return_aids, only: [:index]

  def index
    @finding_aids = FindingAid.all

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

    filtered_aids = arrays.blank? ? all_aids : arrays

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
      if params[:id]
        @finding_aid = FindingAid.find(params[:id])
      elsif params[:path]
        @finding_aid = FindingAid.find_by_path(params[:path])
        redirect_to finding_aid_path(@finding_aid), status: 301
      end
    end
end
