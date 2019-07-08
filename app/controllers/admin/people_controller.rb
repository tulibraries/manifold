# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    def detach
      @person = Person.find(params[:id])
      @person.image.purge
      flash[:notice] = "Image purged"
      redirect_to admin_person_path
    end
  end
end
