# frozen_string_literal: true

module PersonsHelper

	def depts_list(person)
		depts = Person.find(person.id).groups.select { |group| group.group_type == "Department" }
		depts.collect(&:label).join(",<br />")
	end

	def specialties(person)
		person.specialties.drop(1).each do |specialty|
      specialty
    end
  end
	
end
