# frozen_string_literal: true

module PersonsHelper
  def get_loc_name(id)
    location = Building.find_by(id: id)
    unless location.nil?
      location.name
    end
  end

  def get_dept_name(id)
    department = Group.find_by(id: id)
    unless department.nil?
      department.name
    end
  end

  def depts_list(person)
    depts = person.groups.select { |group| group.group_type == "Department" }
    depts.collect(&:label).join(", ")
  end
end
