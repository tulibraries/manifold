# frozen_string_literal: true

module PersonsHelper
  def get_loc_name(id)
    location = Building.find_by(id:)
    unless location.nil?
      location.name
    end
  end

  def get_dept_name(id)
    department = Group.find_by(id:)
    unless department.nil?
      department.name
    end
  end

  def depts_list(person)
    depts = person.groups.select { |group| group.group_type == "Department" }
    depts.collect(&:label).join("<br />")
  end

  def print_specialists
    if params[:specialists].present?
      if params[:department].present?
        link_to t("manifold.people.filters.specialists_print"), specialists_print_path(dept: params[:department]), class: "ms-2", id: "specialist-print"
      else
        link_to t("manifold.people.filters.specialists_print"), specialists_print_path, class: "ms-2", id: "specialist-print"
      end
    end
  end

  def specialists_link
    link_text = t("manifold.people.filters.limit_to_specialists")
    limited_text = t("manifold.people.filters.limited_to_specialists")
    see_all = t("manifold.people.filters.see_all_specialists")

    dept = params[:department]
    specialists = params[:specialists]
    speciality = params[:specialty]

    if specialists.present?
      limited_text
    else
      if dept.present?
        link_to link_text, people_path(specialists: true, department: dept)
      elsif speciality.present?
        link_to see_all, people_path(specialists: true)
      else
        link_to link_text, people_path(specialists: true)
      end
    end
  end
end
