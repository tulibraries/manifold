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
    depts.collect(&:label).join(",<br />")
  end

  def filter_tags
    tags = []
    unless params[:specialists].nil?
      tags << "Subject Librarians Only&nbsp;<a href=\"#{people_path}\">X</a>"
    end
    unless params[:specialty].nil?
      tags << "#{params[:specialty]}&nbsp;<a href=\"#{people_path(request.query_parameters.except(:specialty).merge(page: 1))}\">X</a>"
    end
    unless params[:location].nil?
      tags << "#{get_loc_name(params[:location])}&nbsp;<a href=\"#{people_path(request.query_parameters.except(:location).merge(page: 1))}\">X</a>"
    end
    unless params[:department].nil?
      tags << "#{get_dept_name(params[:department])}&nbsp;<a href=\"#{people_path(request.query_parameters.except(:department).merge(page: 1))}\">X</a>"
    end
    tags
  end
end
