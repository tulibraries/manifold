module Admin
  class PeopleController < Admin::ApplicationController

    def create
      person_params = params[:person]
      person_params.permit!
      person = Person.new(person_params)

      if person.save
        redirect_to(
          [namespace, person],
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, person),
        }
      end
    end


    def update
      person = Person.find(params[:id])
      person_params = params[:person]
      person_params.permit!
      if person.update(person_params)
        redirect_to(
          [namespace, person],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, person),
        }
      end
    end
    
  end
end
