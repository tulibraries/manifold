# frozen_string_literal: true

module Admin::Draftable
  extend ActiveSupport::Concern

  def create
    requested_resource.apply_draft if resource_params[:apply_draft_fields] == "1"
    super
  end

  def update
    requested_resource.assign_attributes(resource_params)
    requested_resource.apply_draft if resource_params[:apply_draft_fields] == "1"
    super
  end
end
