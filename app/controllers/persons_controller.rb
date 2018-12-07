# frozen_string_literal: true

class PersonsController < ApplicationController
  load_and_authorize_resource
  before_action :set_person, only: [:show]

  # GET /persons
  # GET /persons.json
  def index
    @persons = Person.all.order(:last_name, :first_name)
  end

  # GET /persons/1
  # GET /persons/1.json
  def show
    @building = Building.find_by("id = ?", @person.spaces.last.building_id)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end
end
