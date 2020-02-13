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
    @ezborrow_link = ExternalLink.find_by(slug: "ezborrow")
    @illiad_link = ExternalLink.find_by(slug: "illiad")
    @refworks_link = ExternalLink.find_by(slug: "refworks")
    @jobs_link = Webpage.find_by(slug: "jobs")
    @publications_link = Webpage.find_by(slug: "system-summary")
    @numbers_link = Webpage.find_by(slug: "numbers")
    @social_links = Webpage.find_by(slug: "social-media")
    @donate_link = Policy.find_by(slug: "donations")
    @diversity_link = Webpage.find_by(slug: "diversity")
    @standards_link = Policy.find_by(slug: "standards")
    @privacy_link = Service.find_by(slug: "privacy")
    @tu_homepage_link = ExternalLink.find_by(slug: "tu-homepage")
    @org_charts = ExternalLink.find_by(slug: "org-charts")
    @staff_forms = ExternalLink.find_by(slug: "staff-forms")
    @chat_link = ExternalLink.find_by(slug: "chat-link")
    @db_az_link = ExternalLink.find_by(slug: "db-az")
    @journal_finder = Rails.configuration.primo_articles_url
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
    @today = Time.zone.today
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
      location = Building.where(slug: params[:id])
      @location = location.first.hours unless location.first.nil?
    elsif params[:controller] == "spaces"
      location = Space.where(slug: params[:id])
      @location = location.first.hours unless location.first.nil?
    elsif params[:controller] == "services"
      location = Service.where(slug: params[:id])
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
                  "scrc",
                  "scholars_studio",
                  "ask_a_librarian",
                  "asrs",
                  "guest_computers",
                  "cafe"
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
