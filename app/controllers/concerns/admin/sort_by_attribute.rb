# frozen_string_literal: true

module Admin::SortByAttribute
  extend ActiveSupport::Concern

  included do
    before_action :default_params
  end


  def default_params
    params[resource_name] = {}
    params[resource_name][:order] ||= (sort_by || "created_at")
    params[resource_name][:direction] ||= (sort_direction || "asc")
  end

  # May be overriden by including in controller
  # value should be the name of an atrtibute to sort by
  # e.g. 'title' or :start_time
  def sort_by
  end

  # May be overriden by including controller
  def sort_direction
  end
end
