# frozen_string_literal: true

class PoliciesController < ApplicationController
  load_and_authorize_resource
  before_action :set_policy, only: [:show]
  before_action :navigation_items, only: [:show]

  def index
    @policies = Policy.all
    respond_to do |format|
      format.html
      format.json { render json: PolicySerializer.new(@policies) }
    end
  end

  def show
    @categories = @policy.categories
    respond_to do |format|
      format.html
      format.json { render json: PolicySerializer.new(@policy) }
    end
  end

  def navigation_items
    @nav_items = []
    @policy.categories.each do |cat|
      cat.items.each do |item|
        unless item.id == @policy.id
          @nav_items << item
        end
      end
    end
  end

  private
    def set_policy
      @policy = Policy.find(params[:id])
    end
end
