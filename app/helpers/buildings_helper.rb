# frozen_string_literal: true

module BuildingsHelper
  def todays_building_hours
    hours = @todays_hours.first.hours
    unless hours.nil?
      todays_hours = hours
    else
      ""
    end
  end
  def future_building_hours
    unless @building.hours.blank?
      link_to "See future hours", hour_path(@building.hours)
    end
  end
  def todays_date
    @today.to_date.strftime("%^A, %^B %d, %Y ")
  end
  def phone_formatted
    number_to_phone(@building.phone_number, area_code: true)
  end
end
