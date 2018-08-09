module Admin
  class PeopleController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Person.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Person.find_by!(slug: param)
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information

    def create
      person_params = params[:person]
      person_params.permit!
      # person_params[:photo] = Person.photo.attach(params[:photo])
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
      # person_params[:photo] = Person.photo.attach(params[:photo])
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
