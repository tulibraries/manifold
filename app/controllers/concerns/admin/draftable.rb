# frozen_string_literal: true

module Admin::Draftable
  extend ActiveSupport::Concern

  def create
    requested_resource.apply_draft if resource_params[:publish] == "1"
    super
  end

  def update
    requested_resource.update(params[resource_name].to_unsafe_hash)
    requested_resource.assign_attributes(resource_params)
    requested_resource.apply_draft if resource_params[:publish] == "1"
    if requested_resource.save
      redirect_to resource_path, notice: "#{resource_name.titleize} has updated successfully"
    else
      render :edit
    end
  end

  def resource_path
    self.send("admin_#{resource_name.to_s}_path")
  end
end
