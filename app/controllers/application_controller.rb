# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ServerErrors
  before_action :failover, :script_nonce
  before_action :get_alert, :covid_alert
  before_action :set_paper_trail_whodunnit
  before_action :locations, :set_dates, :set_location
  before_action :show_hours, :menu_items, unless: ->(c) { ["accounts/omniauth_callbacks", "devise/sessions"].include?(c.controller_path) }

  rescue_from ActionController::Redirecting::UnsafeRedirectError do
    redirect_to root_url
  end

  def failover
    f = ApplicationFailover.all.first
    if f.present?
      @search_mode = f.turn_on == true ? "failover-" : ""
      @search = f.turn_on ? "alt-page-search" : "page-search"
      @header_search = f.turn_on ? "alt-header-search" : "header-search"
      @mobile_search = f.turn_on ? "alt-mobile-search" : "mobile-search"
    end
  end

  def menu_items
    about_menu = MenuGroup.find_by(slug: "about-page")
    @about_menu = about_menu.menu_group_categories.sort_by { |mg| mg.weight } if about_menu.present?
    visit_menu = MenuGroup.find_by(slug: "visit")
    @visit_menu = visit_menu.menu_group_categories.sort_by { |mg| mg.weight } if visit_menu.present?
    research_menu = MenuGroup.find_by(slug: "research-services")
    @research_menu = research_menu.menu_group_categories.sort_by { |mg| mg.weight } if research_menu.present?
    @quick_links = Category.find_by(slug: "quick-links")
  end

  def get_alert
    @alert = Alert.where(published: true).where(for_header: false)
  end

  def covid_alert
    @covid_alert = Alert.where(published: true).where(for_header: true)
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

  def script_nonce
    if Rails.env.production?
      @nonce = SecureRandom.base64(12)
    end
  end

  def home
  end

  protected
    # Devise has current_user hard_coded so if we use anything other than
    # user, we have no access to the devise object. So, we need to override
    # current_user to return the current account. This is needed both
    # in ApplicationController and in Admin::ApplicationController

    def current_user
      current_account
    end
end
