# frozen_string_literal: true

class PoliciesController < ApplicationController
  include HasCategories
  include SetInstance
  include RedirectLogic
  before_action :set_policy, only: [:show]
  include SerializableRespondTo

  def index
    serializable_index
  end

  def show
    @header_alert = @policy.covid_alert
    @categories = @policy.categories
    serializable_show
  end

  def list_item(category)
    cat_link(category, @policy)
  end
  helper_method :list_item

  private
    def set_policy
      @policy = find_instance
      return redirect_or_404(@policy)
    end

    def permitted_attributes
      super + [:draft_description, :publish]
    end
end
