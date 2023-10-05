# frozen_string_literal: true

module Admin::Draftable
  extend ActiveSupport::Concern

  def update
    klass = params[:controller].split("/").last.classify
    resource_name = klass.underscore
    draftable_classes = [Building, Category, Collection, Event, Exhibition, FindingAid, Group, Policy, Service, Space, Webpage]
    draftable_class = draftable_classes.find { |x| x.name == klass }
    if draftable_class.nil?
      raise "Unable to find the draftable class."
    end
    requested_resource = draftable_class.find(params[:id])
    resource_params = params[resource_name]
    if resource_params[:images] && resource_params[:images].size > 0
      # binding.pry
      resource_params[:images].each do |image|
        requested_resource.images.attach(image)
      end
    end
    requested_resource.update(params[resource_name].except(:images).to_unsafe_hash)
    apply_draft(requested_resource, resource_params, resource_name) if resource_params[:publish] == "1"
    if requested_resource.save
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
