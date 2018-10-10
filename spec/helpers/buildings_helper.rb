# frozen_string_literal: true

module BuildingsHelper
  def todays_hours
    "9am-5pm"
  end
  def todays_date
    today = Date.new
    today.to_date.strftime("%^A, %^B %d, %Y ")
  end
  def phone_formatted
    "(215) 204-3836"
  end
end
