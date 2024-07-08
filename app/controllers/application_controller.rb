# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ServerErrors
  before_action :failover, :script_nonce
  before_action :get_alert, :covid_alert
  before_action :set_paper_trail_whodunnit
  before_action :menu_items, unless: ->(c) { ["accounts/omniauth_callbacks", "devise/sessions"].include?(c.controller_path) }

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
