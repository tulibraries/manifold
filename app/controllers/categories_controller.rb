# frozen_string_literal: true

class CategoriesController < ApplicationController
  include HasCategories
  include RedirectLogic
  before_action :set_category, only: [:show]

  def show
    respond_to do |format|
      format.html {
        @nav_items = []
        @category.items.each do |item|
          @nav_items << item
        end
      }
    end
  end

  private
    def set_category
      @category = Category.find_by(id: params[:id])
    end
end
