# frozen_string_literal: true

class Google::HoursComponent < ViewComponent::Base
  include ViewComponent::UseHelpers
  def initialize(hours:, date:)
    hours = hours&.values
    @locations = build_hours(hours)
    set_dates(date)
  end

  private

    def build_hours(hours)

      date_range = hours.map{|h| h[0]}

      spaces = [
        {:charles => date_range.zip(hours.map{|h| h[1]})}, 
        {:service_zone => date_range.zip(hours.map{|h| h[2]})}, 
        {:cafe => date_range.zip(hours.map{|h| h[3]})}, 
        {:scrc => date_range.zip(hours.map{|h| h[4]})}, 
        {:scholars_studio => date_range.zip(hours.map{|h| h[5]})}, 
        {:ask_a_librarian => date_range.zip(hours.map{|h| h[6]})}, 
        {:asrs => date_range.zip(hours.map{|h| h[7]})}, 
        {:guest_computers => date_range.zip(hours.map{|h| h[8]})}, 
        {:blockson => date_range.zip(hours.map{|h| h[9]})}, 
        {:ambler => date_range.zip(hours.map{|h| h[10]})}, 
        {:ginsburg => date_range.zip(hours.map{|h| h[11]})}, 
        {:podiatry => date_range.zip(hours.map{|h| h[12]})}, 
        {:innovation => date_range.zip(hours.map{|h| h[13]})}, 
        {:"24-7" => date_range.zip(hours.map{|h| h[14]})}, 
        {:exhibits => date_range.zip(hours.map{|h| h[15]})}
      ]
      locations = [
        {:charles => [spaces[0], spaces[1], spaces[2], spaces[3], spaces[4], spaces[6], spaces[7], spaces[13], spaces[14]]},
        {:ambler => [spaces[9]]},
        {:blockson => [spaces[8]]},
        {:ginsburg => [spaces[10], spaces[12]]},
        {:podiatry => [spaces[11]]},
        {:online => [spaces[5]]}
      ]
    end

    # date_range.select{|date| date.keys.first == Time.zone.today.strftime("%A, %B %-d, %Y")}


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

end
