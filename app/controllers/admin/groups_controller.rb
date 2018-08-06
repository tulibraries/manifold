module Admin
  class GroupsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Group.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Group.find_by!(slug: param)
    # end

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

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
