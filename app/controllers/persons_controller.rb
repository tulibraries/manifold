# frozen_string_literal: true

class PersonsController < ApplicationController
  load_and_authorize_resource
  before_action :set_person, only: [:show]
  before_action :get_persons, only: [:index]

  def index

    @persons_list = @persons.page params[:page]

    @specialists = @persons.where.not(specialties: nil)
    @specialists_list = @specialists.page params[:page]

    @subjects = (@persons.where.not(specialties: nil).collect { |p| p.specialties }.flatten.uniq.sort).reject!{|s| s.empty?}
    @departments = (@persons.where.not(groups: nil).collect { |p| p.groups }.flatten.uniq.sort)
    @locations = (@persons.where.not(spaces: nil).collect { |p| p.spaces }.flatten.uniq.sort)
    
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(@persons.to_a) }
    end
  end

  def show
    @building = Building.find_by("id = ?", @person.spaces.last.building_id)
    @departments = @person.groups.sort.select { |group| group.group_type == "Department" }
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(@person) }
    end
  end

  def get_persons
    unless params[:id].nil?
      @persons = Person.find_by(id: params[:id])
    else
      @persons = Person.all.order(:last_name, :first_name)
    end
  end

  private
    def set_person
      @person = Person.find(params[:id])
    end
end
