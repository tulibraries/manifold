# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def todays_date
    @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    @today.to_date.strftime("%^A, %^B %d, %Y ")
  end
end
