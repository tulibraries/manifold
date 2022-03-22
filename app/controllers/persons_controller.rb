# frozen_string_literal: true

class PersonsController < ApplicationController
  before_action :set_person, only: [:show]
  before_action :get_persons, only: [:index]
  before_action :set_filters, only: [:index]
  include SerializableRespondTo

  def index
    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(Person.all.to_a) }
    end
  end

  def set_filters
    if params[:department].present?
      d = Group.friendly.find(params[:department])
      if d.present?
        key = "Department"
        value = d.label
      end
    end

    if params[:specialty].present?
      key = "Specialty"
      value = params[:specialty]
    end

    if params[:search].present?
      key = "Search"
      value = params[:search]
    end

    @filter = [key, value]
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
      .collect { |p| [ p.name, p.slug ] }
      .sort
      .uniq
  end

  def get_persons
    all = Person.all
    @subjects = get_specialty_filter_values(all)
    @departments = get_department_filter_values(all)
    if params[:search].present?
      @filtered_persons = Person.search(params[:search])
    else
      @filtered_persons = Person
      .is_specialist(params[:specialists])
      .with_specialty(params[:specialty])
      .in_department(params[:department])
      .order(:last_name, :first_name)
    end
    @persons_list = @filtered_persons.page(params[:page])
  end

  def specialists_print
    @persons_list = Person.specialists
  end

  private
    def set_person
      @person = Person.friendly.find(params[:id])
    end
end
