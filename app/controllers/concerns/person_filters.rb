# frozen_string_literal: true

module PersonFilters
  extend ActiveSupport::Concern

  def locations_list(persons)
    to_add = persons.select { |person| person.spaces.any? { |space| space.slug == params[:location] }  }

    location_people = []

    to_add.each do |person|
      location_people << person
    end

    location_people
  end

  def departments_list(persons)
    to_add = persons.select { |person| person.groups.any? { |group| group.slug == params[:department] && group.group_type == "Department" }  }

    dept_people = []

    to_add.each do |person|
      dept_people << person
    end

    dept_people
  end

  def specialties_list(persons)
    to_add = persons.select { |person| person.specialties.try(:any?) { |subject| subject == params[:specialty] }  }

    special_people = []

    to_add.each do |person|
      special_people << person
    end

    special_people
  end
end
