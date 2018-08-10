module Admin
  class GroupsController < Admin::ApplicationController

    def create
      group_params = params[:group]
      group_params.permit!
      group_params[:chair_dept_head] = Person.find_by_id(group_params[:chair_dept_head].to_i)
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
      group_params[:chair_dept_head] = Person.find_by_id(group_params[:chair_dept_head].to_i)
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
