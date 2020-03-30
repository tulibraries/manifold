# frozen_string_literal: true

class PoliciesController < ApplicationController
  include HasCategories
  before_action :set_policy, only: [:show]

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

  def list_item(category)
    cat_link(category, @policy)
  end
  helper_method :list_item

  private
    def set_policy
      if Policy.find_by(slug: params[:id])
        @policy = Policy.friendly.find(params[:id])
      else
        @policy = Policy.find_by(id: params[:id])
      end
      return redirect_or_404 unless @policy
    end
end
