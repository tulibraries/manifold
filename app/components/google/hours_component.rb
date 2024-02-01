# frozen_string_literal: true

class Google::HoursComponent < ViewComponent::Base
  include ViewComponent::UseHelpers
  def initialize(hours:, date:)
    @hours = hours&.values
    @buildings = [
      {
        slug: "charles",
        spaces: [
                  "charles",
                  "24-7",
                  "asrs",
                  "guest_computers",
                  "scholars_studio",
                  "service_zone",
                  "scrc",
                  "cafe",
                  "exhibits"
                ]
      },
      {
        slug: "ambler",
        spaces: ["ambler"]
      },
      {
        slug: "blockson",
        spaces: ["blockson"]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg", "innovation"]
      },
      {
        slug: "podiatry",
        spaces: ["podiatry"]
      },
      {
        slug: "online",
        spaces: ["ask_a_librarian"]
      }
    ]
    set_dates(date)
  end

  private

    def set_dates(date)
      @today = Time.zone.today
      @date_picker_date = date ? date : @today
      begin
        @date = date.nil? ? @today : Date.parse(date)
      rescue ArgumentError
        @date = @today
      end

      unless date.nil?
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
    
    def location_name(slug)
      if slug == "online" || slug == "drop_in"
        name = "Online" if slug == "online"
        name = "Drop-in Research Help" if slug == "drop_in"
      else
        location = Building.find_by(hours: slug)
        unless location.nil?
          name = location.name
        end
        if location.nil?
          location = Space.find_by(hours: slug)
          unless location.nil?
            name = location.name
          end
        end
        if location.nil?
          location = Service.find_by(hours: slug)
          unless location.nil?
            name = location.title
          end
        end
      end
      name
    end

    def location_link(slug)
      if slug == "online" || slug == "drop_in"
        name = "Online" if slug == "online"
        name = link_to("Drop-in Research Help", Service.find_by(hours: "ask_a_librarian")) if slug == "drop_in"
      else
        location = Building.find_by(hours: slug)
        unless location.nil?
          name = link_to location.name, location
        end
        if location.nil?
          location = Space.find_by(hours: slug)
          unless location.nil?
            name = link_to location.name, location
          end
        end
        if location.nil?
          location = Service.find_by(hours: slug)
          unless location.nil?
            name = link_to location.title, location
          end
        end
      end
      name
    end

    def has_spaces?(spaces)
      if spaces.empty?
        return false
      end
      spaces.each do |space|
        if defined?(space[1].first.location_id).nil?
          return false
        end
      end
      return true
    end

    def build_hours_data_structure(input)
      input.map do |building|
        building[:spaces].map! do |space|
          { slug: space, hours: LibraryHour.where(location_id: space, date: @monday..@sunday) }
        end
        building
      end
    end

end
