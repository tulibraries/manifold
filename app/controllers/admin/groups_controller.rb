# frozen_string_literal: true

module Admin
  class GroupsController < Admin::ApplicationController
    def create
      group_params = params[:group]
      group_params.permit!
      group_params[:spaces] = Space.find(group_params[:spaces])
      group = Group.new(group_params)

      if group.save
        redirect_to(
          [namespace, group],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, group),
        }
      end
    end

    def update
      group = Group.find(params[:id])
      group_params = params[:group]
      group_params.permit!
      unless group_params[:spaces].blank?
        group_params[:spaces] = Space.find(group_params[:spaces]) 
      else 
        group_params[:spaces] = nil
      end
      if group.update(group_params)
        redirect_to(
          [namespace, group],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, group),
        }
      end
    end
  end
end
