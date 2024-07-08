# frozen_string_literal: true

class Google::TodaysHours < ViewComponent::Base

  def initialize(hours:)
    @hours = hours_today(hours:)
  end

  private

    def hours_today(hours)
      today = Time.zone.today.strftime("%A, %B %-d, %Y")
      hours[:hours].select{ |hour| hour[0] == today }
    end

end
