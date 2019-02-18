# frozen_string_literal: true

class PersonsController < ApplicationController
  load_and_authorize_resource
  before_action :set_person, only: [:show]

  def index
    if params[:id].nil?
      @persons = Person.all.order(:last_name, :first_name)
    else
      @persons = Person.where("last_name LIKE ?", "#{params[:id]}%").order(:last_name, :first_name)
    end
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(@persons.to_a)}
    end
  end

  def show
    @building = Building.find_by("id = ?", @person.spaces.last.building_id)
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(@person)}
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end
end
