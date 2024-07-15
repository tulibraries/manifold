# frozen_string_literal: true

class Google::TodaysHours < ViewComponent::Base
  def initialize(hours:)
    dates = hours.value_ranges[0].values.flatten
    times = hours.value_ranges[1].values.flatten
    @hours = hours_today(dates.zip(times))
  end

  private

    def hours_today(hours)
      today = Time.zone.today.strftime("%A, %B %-d, %Y")
      hours.select { |hour| hour[0] == today }
    end
end
