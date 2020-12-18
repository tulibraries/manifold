# frozen_string_literal: true

module Admin::Draftable
  extend ActiveSupport::Concern

  def update
    klass = params[:controller].split("/").last.classify
    resource_name = klass.underscore
    requested_resource = klass.constantize.find(params[:id])
    resource_params = params[resource_name]

    requested_resource.update(params[resource_name].to_unsafe_hash)
    apply_draft(requested_resource, resource_params, resource_name) if resource_params[:publish] == "1"
    if requested_resource.save
      #render :show
      redirect_to "/admin/#{resource_name.to_s.pluralize}/#{requested_resource[:slug]}", notice: "#{resource_name.to_s.titleize} has updated successfully"
    else
      render :edit
    end
  end

  def apply_draft(resource, resource_params, resource_name)
    params[resource_name].keys.each do |k|
      if k.starts_with?("draft_")
        draft_content = k
        content = k.delete_prefix("draft_")
        resource.update(content => resource_params[draft_content])
      end
    end
  end
end
