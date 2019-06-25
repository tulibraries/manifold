# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Devise has current_user hard_coded so if we us anything other than
  # user, we have no access to the devise object. So, we need to override
  # current_user to return the current account. This is needed both
  # in ApplicationController and in Admin::ApplicationController
  before_action :get_alert, :set_footer
  before_action :set_paper_trail_whodunnit
  before_action :locations, :set_dates, :set_location
  before_action :show_hours

  def get_alert
    @alert = Alert.where(published: true)
  end

  def set_footer
    @footer_buildings = Building.where(add_to_footer: true).take(6)
    @footer_collections = Collection.where(add_to_footer: true).take(6)
    @footer_services = Service.where(add_to_footer: true).take(6)
    @footer_groups = Group.where(add_to_footer: true).take(6)
  end

  def show_hours
    @locations.each do |b|
      if b[:slug] == @location
        b[:spaces].map! do |space|
          space = [b[:slug], LibraryHour.where(location_id: space, date: @monday..@sunday + 1)]
        end
      else
        if b[:spaces].include?(@location)
          @hours_type = "space"
          b[:spaces].each do |spacename|
            if spacename == @location
              b[:spaces].map! do |space|
                space = [b[spacename.to_sym], LibraryHour.where(location_id: spacename, date: @monday..@sunday + 1)]
              end
            end
          end
        end
      end
    end
  end

  def set_dates
    @today = Date.today
    @date = params[:date].nil? ? @today : Date.parse(params[:date])

    unless params[:date].nil?
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

  def set_location
    if params[:controller] == "buildings"
      location = Building.where(id: params[:id])
      @location = location.first.hours unless location.first.nil?
    elsif params[:controller] == "spaces"
      location = Space.where(id: params[:id])
      @location = location.first.hours unless location.first.nil?
    elsif params[:controller] == "services"
      location = Service.where(id: params[:id])
      @location = location.first.hours unless location.first.nil?
    end
  end

  def locations
    @locations = [
      {
        slug: "ambler",
        spaces: ["ambler"]
      },
      {
        slug: "blockson",
        spaces: ["blockson"]
      },
      {
        slug: "charles",
        spaces: [
                  "charles",
                  "service_zone",
                  "cafe",
                  "scrc",
                  "scholars_studio",
                  "success_center",
                  "ask_a_librarian",
                  "asrs",
                  "guest_computers"
                ]
      },
      {
        slug: "ginsburg",
        spaces: ["ginsburg", "innovation"]
      },
      {
        slug: "podiatry",
        spaces: ["podiatry"]
      }
    ]
  end

  protected

    def current_user
      current_account
    end
end
