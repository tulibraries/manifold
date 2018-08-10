module Admin
  class BuildingsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Building.
    #     page(params[:page]).
    #     per(10)
        
    # end

    def create
      building_params = params[:building]
      building_params.permit!
      building = Building.new(building_params)

      if person.save
        redirect_to(
          [namespace, building],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, building),
        }
      end
    end


    def update
      building = Building.find(params[:id])
      building_params = params[:building]
      building_params.permit!
      if building.update(building_params)
        redirect_to(
          [namespace, building],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, building),
        }
      end
    end


  end
end
