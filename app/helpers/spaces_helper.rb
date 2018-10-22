# frozen_string_literal: true

module SpacesHelper
  @today = Date.today.strftime("%Y-%m-%d 00:00:00")

  def todays_space_hours
    unless @space.hours.blank?
      todays_hours = LibraryHours.where(location_id: @space.hours, date: @today)
    else
      todays_hours = LibraryHours.where(location_id: @space.building.hours, date: @today)
    end 

    #binding.pry 
    @todays_hours = todays_hours.first.hours
    unless @todays_hours.nil?
      @todays_hours
    else
      ""
    end
  end
  def future_space_hours
    unless @space.hours.blank?
      link_to "See future hours", hour_path(@space.hours)
    else 
      link_to "See future hours", hour_path(@space.building.hours)
    end
  end
  def todays_date
    @today.to_date.strftime("%^A, %^B %d, %Y ")
  end
  def phone_formatted(num)
    number_to_phone(num, area_code: true)
  end
end
