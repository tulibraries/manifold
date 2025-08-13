# frozen_string_literal: true

class Google::HoursComponent < ViewComponent::Base
  include ViewComponent::UseHelpers
  include LibraryHoursHelper

  def initialize(hours:, date:)
    hours = hours&.values
    @locations = build_hours(hours)
    set_dates(date)
  end

  private

    def build_hours(hours)
      @date_range = hours.map { |h| h[0] }
      spaces = {
        charles: @date_range.zip(hours.map { |h| h[1] }),
        service_zone: @date_range.zip(hours.map { |h| h[2] }),
        cafe: @date_range.zip(hours.map { |h| h[3] }),
        scrc: @date_range.zip(hours.map { |h| h[4] }),
        scholars_studio: @date_range.zip(hours.map { |h| h[5] }),
        ask_a_librarian: @date_range.zip(hours.map { |h| h[7] }),
        asrs: @date_range.zip(hours.map { |h| h[8] }),
        guest_computers: @date_range.zip(hours.map { |h| h[9] }),
        blockson: @date_range.zip(hours.map { |h| h[10] }),
        ambler: @date_range.zip(hours.map { |h| h[11] }),
        ginsburg: @date_range.zip(hours.map { |h| h[12] }),
        podiatry: @date_range.zip(hours.map { |h| h[13] }),
        innovation: @date_range.zip(hours.map { |h| h[14] }),
        "24-7": @date_range.zip(hours.map { |h| h[15] }),
        exhibits: @date_range.zip(hours.map { |h| h[17] })
      }
      locations = {
        charles: { charles: spaces[:charles],
                  "24-7": spaces[:"24-7"],
                  asrs: spaces[:asrs],
                  guest_computers: spaces[:guest_computers],
                  scholars_studio: spaces[:scholars_studio],
                  service_zone: spaces[:service_zone],
                  scrc: spaces[:scrc],
                  cafe: spaces[:cafe],
                  exhibits: spaces[:exhibits] },
        ambler: { ambler: spaces[:ambler] },
        blockson: { blockson: spaces[:blockson] },
        ginsburg: { ginsburg: spaces[:ginsburg], innovation: spaces[:innovation] },
        podiatry: { podiatry: spaces[:podiatry] },
        online: { ask_a_librarian: spaces[:ask_a_librarian] }
      }
    end

    def set_dates(date)
      @today = Time.zone.today
      @date_picker_date = date ? date : @today
      begin
        @date = date.present? ? date.to_date : @today
      rescue ArgumentError
        @date = @today
      end

      if date.present?
        @monday = @date.beginning_of_week
        @sunday = @date.end_of_week
        @next_week = @date.next_week
        @last_week = @date.prev_week
      else
        @monday = @today.beginning_of_week
        @sunday = @today.end_of_week
        @next_week = @today.next_week
        @last_week = @today.prev_week
      end
    end

    def start_at
      if @date_range.include? @date.to_date.strftime("%A, %B %-d, %Y")
        @date_range.index { |d| d == @monday.strftime("%A, %B %-d, %Y") }
      else
        return
      end
    end
end
