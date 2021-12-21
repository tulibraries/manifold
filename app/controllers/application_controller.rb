# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ServerErrors
  before_action :get_alert
  before_action :set_paper_trail_whodunnit
  before_action :locations, :set_dates, :set_location
  before_action :show_hours, :menu_items, unless: ->(c) { ["accounts/omniauth_callbacks", "devise/sessions"].include?(c.controller_path) }

  def menu_items
    @empty_abouts = []
    @empty_visits = []
    @empty_researches = []

    about = Category.find_by(slug: "about-page")
    @about_items = Category.find_by(slug: "about-page").items(exclude: [about]) if Category.find_by(slug: "about-page").present?
    @about_items.each do |item|
      if item.items.count < 1
        @empty_abouts << item
        @about_items.delete(Category.find(item.id))
      end if item.is_a?(Category)
    end if @about_items.present?

    @visit_items = Category.find_by(slug: "visit").items if Category.find_by(slug: "visit").present?
    @visit_items.each do |item|
      if item.items.count < 1
        @empty_visits << item
        @visit_items.delete(Category.find(item.id))
      end if item.is_a?(Category)
    end if @visit_items.present?

    @research_items = Category.find_by(slug: "research-services").items if Category.find_by(slug: "research-services").present?
    @research_items.each do |item|
      if item.items.count < 1
        @empty_researches << item
        @research_items.delete(Category.find(item.id))
      end if item.is_a?(Category)
    end if @research_items.present?
  end

  def get_alert
    @alert = Alert.where(published: true).where(for_header: false)
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
    # Devise has current_user hard_coded so if we use anything other than
    # user, we have no access to the devise object. So, we need to override
    # current_user to return the current account. This is needed both
    # in ApplicationController and in Admin::ApplicationController

    def current_user
      current_account
    end
end
