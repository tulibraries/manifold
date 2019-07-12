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
    @ezborrow_link = ExternalLink.find_by_title("EZBorrow")
    @illiad_link = ExternalLink.find_by_title("Log into ILLiad")
    @refworks_link = ExternalLink.find_by_title("RefWorks at Temple")
    @jobs_link = Page.find_by_title("Employment Opportunities")
    @publications_link = Page.where("title LIKE ?", "Temple University Library System Summary%").first
    @numbers_link = Page.find_by_title("Frequently called numbers")
    @social_links = Page.find_by_title("Connect with us on social media")
    @donate_link = Page.where("title LIKE ?", "Donate books % gifts-in-kind").first
  end

  def show_hours
    @locations.each do |b|
      if b[:slug] == @location
        b[:spaces].map! do |space|
          space = [b[:slug], LibraryHour.where(location_id: space, date: @monday..@sunday + 1)]
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
