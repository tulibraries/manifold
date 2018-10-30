#frozen_string_literal: true

module Admin
  class PoliciesController < Admin::ApplicationController
    def create
      policy_params = params[:policy]
      policy_params.permit!
      policy = Policy.new(policy_params)

      if policy.save
        redirect_to(
          [namespace, policy],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, policy),
        }
      end
    end

    def update
      policy = Policy.find(params[:id])
      policy_params = params[:policy]
      policy_params.permit!
      if policy.update(policy_params)
        redirect_to(
          [namespace, policy],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, policy),
        }
      end
    end
  end
end
