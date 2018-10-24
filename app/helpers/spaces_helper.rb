# frozen_string_literal: true

module SpacesHelper
  # def todays_hours
  #   hours = @todays_hours.first.hours
  #   unless hours.nil?
  #     todays_hours = hours
  #   else
  #     ""
  #   end
  # end
  # def todays_date
  #   @today.to_date.strftime("%^A, %^B %d, %Y ")
  # end
  def phone_formatted(num)
    number_to_phone(num, area_code: true)
  end
end
