# frozen_string_literal: true

class PersonsController < ApplicationController
  include PersonFilters
  before_action :set_person, only: [:show]
  before_action :get_persons, only: [:index]

  def index
    @persons = Person.all

    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(Person.all.to_a) }
    end
  end

  def show
    @buildings = @person.spaces.map { |space| space.building }.uniq
    @departments = @person.groups.sort.select { |group| group.group_type == "Department" }

    respond_to do |format|
      format.html
      format.json { render json: PersonSerializer.new(@person) }
    end
  end

  def get_specialty_filter_values(people)
    people
      .map(&:specialties)
      .reject(&:nil?)
      .flatten
      .sort
      .uniq
  end

  def get_department_filter_values(people)
    people
      .map(&:groups)
      .select { |group| group.any? { |group| group.group_type == "Department" } }
      .flatten
      .sort
      .uniq
  end

  def get_location_filter_values(people)
    people
      .map(&:spaces)
      .flatten
      .sort
      .uniq
  end

  def get_persons
    all_persons = Person.group(:id).order(:last_name, :first_name)

    if params.has_key?("specialists")
      subjectivists = all_persons.select { |person| !person.specialties.nil? && person.specialties.reject(&:empty?).present? }
    end
    if params.has_key?("specialty")
      specialists = specialties_list(all_persons)
    end
    if params.has_key?("location")
      locationists = locations_list(all_persons)
    end
    if params.has_key?("department")
      departmentalists = departments_list(all_persons)
    end

    arrays = [Array(subjectivists), Array(specialists), Array(locationists), Array(departmentalists)].reject(&:empty?).reduce(:&) || []

    if arrays.present?
      all_persons = arrays
    end

    @filtered_persons = Person.all
    .order(:last_name, :first_name)
      # .in_department(department)
      # .at_location(location)
      # .with_specialty(specialties)

    @persons_list = @filtered_persons.page params[:page]
    return_filters(@filtered_persons)
  end

  def return_filters(filtered_persons)
    @subjects = get_specialty_filter_values(filtered_persons)
    @departments = get_department_filter_values(filtered_persons)
    @locations = get_location_filter_values(filtered_persons)
    # binding.pry
  end

  def department
    params[:department]
  end

  def location
    params[:location]
  end


  private
    def set_person
      @person = Person.friendly.find(params[:id])
      @department = @person.groups.collect.reject { |g| g.group_type != "Department" }.uniq.sort
      @location = @person.spaces.collect.uniq.sort
    end
end
