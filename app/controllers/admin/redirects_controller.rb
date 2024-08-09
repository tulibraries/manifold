# frozen_string_literal: true

module Admin
  class RedirectsController < Admin::ApplicationController
    def find_resource(param)
      scoped_resource.find(param)
    end

    def resource_params
      params.require(resource_class.model_name.param_key)
        .permit(dashboard.permitted_attributes(action_name))
        .transform_values { |v| read_param_value(v) }
    end
  end
end
