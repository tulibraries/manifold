# frozen_string_literal: true

module LibraryHoursHelper
  def location_name(slug)
    if slug == "online" || slug == "drop_in"
      name = "Online" if slug == "online"
      name = "Drop-in Research Help" if slug == "drop_in"
    else
      location = Building.find_by(hours: slug)
      unless location.nil?
        name = location.name
      end
      if location.nil?
        location = Space.find_by(hours: slug)
        unless location.nil?
          name = location.name
        end
      end
      if location.nil?
        location = Service.find_by(hours: slug)
        unless location.nil?
          name = location.title
        end
      end
    end
    name
  end

  def location_link(slug)
    if slug == "online" || slug == "drop_in"
      name = "Online" if slug == "online"
      name = link_to("Drop-in Research Help", Service.find_by(hours: "ask_a_librarian")) if slug == "drop_in"
    else
      location = Building.find_by(hours: slug)
      unless location.nil?
        name = link_to location.name, location
      end
      if location.nil?
        location = Space.find_by(hours: slug)
        unless location.nil?
          name = link_to location.name, location
        end
      end
      if location.nil?
        location = Service.find_by(hours: slug)
        unless location.nil?
          name = link_to location.title, location
        end
      end
    end
    name
  end

  def has_spaces?(spaces)
    if spaces.first.second.empty?
      return false
    end
    spaces.each do |space|
      if defined?(space[1].first.location_id).nil?
        return false
      end
    end
    return true
  end
end
