# frozen_string_literal: true

module Admin
  class GroupsController < Admin::ApplicationController
    def create
      group_params = params[:group]
      group_params.permit!
      group_params[:space] = Space.find(group_params[:space])
      group = Group.new(group_params)

      if group.save
        redirect_to(
          [namespace, group],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          webpage: Administrate::Webpage::Form.new(dashboard, group),
        }
      end
    end

    def update
      group = Group.find(params[:id])
      group_params = params[:group]
      group_params.permit!
      if group_params[:space].present?
        group_params[:space] = Space.find(group_params[:space])
      else
        group_params[:space] = nil
      end
      if group.update(group_params)
        redirect_to(
          [namespace, group],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          webpage: Administrate::Webpage::Form.new(dashboard, group),
        }
      end
    end

    def detach
      @group = Group.find(params[:id])
      attachment = @group.documents_attachments.find(params["attach_id_param"])
      attachment.purge
      flash[:notice] = "attachment purged"
      redirect_to admin_group_path
    end
  end
end
