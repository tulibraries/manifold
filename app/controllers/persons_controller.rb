# frozen_string_literal: true

class PersonsController < ApplicationController
  before_action :set_person, only: [:show]
  before_action :get_persons, only: [:index]
  include SerializableRespondTo

  def index
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(Person.all.to_a) }
    end
  end

  def show
    @buildings = @person.buildings
    @departments = @person.groups.select { |group| group.group_type == "Department" }
                  .sort

    serializable_show
  end

  def get_specialty_filter_values(people)
    people
      .map(&:specialties)
      .compact
      .flatten
      .sort
      .uniq
  end

  def get_department_filter_values(people)
    people
      .map { |p| p.groups.select { |g| g.group_type == "Department" } }
      .flatten
      .sort
      .uniq
  end

  def get_location_filter_values(people)
    people
      .map(&:buildings)
      .flatten
      .sort
      .uniq
  end

  def get_persons
    @filtered_persons = Person
                        .is_specialist(params[:specialists])
                        .with_specialty(params[:specialty])
                        .at_location(params[:location])
                        .in_department(params[:department])
                        .order(:last_name, :first_name)

    @persons_list = @filtered_persons.page(params[:page])
    return_filters(@filtered_persons)
  end

  def return_filters(filtered_persons)
    @subjects = get_specialty_filter_values(filtered_persons)
    @departments = get_department_filter_values(filtered_persons)
    @locations = get_location_filter_values(filtered_persons)
  end

  def specialists_print
    @persons_list = Person.specialists
  end

  private
    def set_person
      @person = Person.friendly.find(params[:id])
    end
end
