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
        {:"24-7" => date_range.zip(hours.map{|h| h[2]})},
        {:asrs => date_range.zip(hours.map{|h| h[3]})}, 
        {:guest_computers => date_range.zip(hours.map{|h| h[4]})},
        {:scholars_studio => date_range.zip(hours.map{|h| h[5]})},
        {:service_zone => date_range.zip(hours.map{|h| h[6]})},
        {:scrc => date_range.zip(hours.map{|h| h[7]})},  
        {:cafe => date_range.zip(hours.map{|h| h[8]})},   
        {:exhibits => date_range.zip(hours.map{|h| h[9]})}, 
        {:ambler => date_range.zip(hours.map{|h| h[10]})}, 
        {:blockson => date_range.zip(hours.map{|h| h[11]})}, 
        {:ginsburg => date_range.zip(hours.map{|h| h[12]})}, 
        {:innovation => date_range.zip(hours.map{|h| h[13]})},
        {:podiatry => date_range.zip(hours.map{|h| h[14]})}, 
        {:ask_a_librarian => date_range.zip(hours.map{|h| h[15]})}, 
      ]
      locations = [
        {:charles => [spaces[0], spaces[1], spaces[2], spaces[3], spaces[4], spaces[5], spaces[6], spaces[7], spaces[8]]},
        {:ambler => [spaces[9]]},
        {:blockson => [spaces[10]]},
        {:ginsburg => [spaces[11], spaces[12]]},
        {:podiatry => [spaces[13]]},
        {:online => [spaces[14]]}
      ]
    end

    def set_dates(date)
      @today = Time.zone.today
      @date_picker_date = date ? date : @today
      begin
        @date = date.present? ? Date.parse(date) : @today
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
    
    def location_name(slug)
      if slug == "online"
        name = "Online"
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
      if slug == "online"
        name = "Online"
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

    def start_at(dates)
      dates.index{|d| d[0] == @today.strftime("%A, %B %-d, %Y")}
    end

    def get_hours(location)
    end

end
