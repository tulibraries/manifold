module Admin
  class SpacesController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Space.
    #     page(params[:page]).
    #     per(10)
    # end

    def create
      space_params = params[:space]
      space_params.permit!
      space = Space.new(space_params)

      if space.save
        redirect_to(
          [namespace, space],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, space),
        }
      end
    end


    def update
      space = Space.find(params[:id])
      space_params = params[:space]
      space_params.permit!
      if space.update(space_params)
        redirect_to(
          [namespace, space],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, space),
        }
      end
    end
  end
end
