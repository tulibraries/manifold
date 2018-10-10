# frozen_string_literal: true

module LibraryHoursHelper
  def location_name(slug)
    location = Building.find_by(hours: slug)
    if location.nil?
      location = Space.find_by(hours: slug)
    end
    # if location.nil?
    #   location = Service.find_by(hours: slug)
    # end
    unless location.nil?
      location.name
    end
  end
end
