# frozen_string_literal: true

class PoliciesController < ApplicationController
  load_and_authorize_resource
  before_action :set_policy, only: [:show]

  def index
    @policies = Policy.all
    respond_to do |format|
      format.html
      format.json { render json: PolicySerializer.new(@policies) }
    end
  end

  def show
    @policies = Policy.all.sort_by { |p| p.name }
    @groups_list = @policies.map { |p| p.category }.flatten.reject(&:blank?).uniq
    @key_group = @policy.category
    respond_to do |format|
      format.html
      format.json { render json: PolicySerializer.new(@policy) }
    end
  end

  private
    def set_policy
      @policy = Policy.find(params[:id])
    end
end
