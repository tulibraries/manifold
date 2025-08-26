# frozen_string_literal: true

class Google::WeeklyHours < ViewComponent::Base
  include ViewComponent::UseHelpers

  def initialize(hours:, location: nil)
    dates = hours.value_ranges[0].values.flatten
    times = hours.value_ranges[1].values.flatten
    @today = Time.zone.today.strftime("%A, %B %-d, %Y")
    date_index = dates.find_index(Time.zone.today.beginning_of_week.strftime("%A, %B %-d, %Y")) || 0
    @weekly_hours = weekly_hours(dates.zip(times), date_index)
  end

  private

    def weekly_hours(hours, index)
      return [] if index.nil? || index >= hours.length
      end_index = [index + 6, hours.length - 1].min
      hours[index..end_index]
    end
end
