# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tude
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.time_zone = "Eastern Time (US & Canada)"
    config.load_defaults 6.0
    config.exceptions_app = self.routes
    config.active_storage.replace_on_assign_to_many = false
    config.tinymce.install
    config.action_view.sanitized_allowed_tags = ["div", "p", "h1", "h2", "h3", "h4", "h5", "h6",
        "ul", "ol", "li", "dl", "dt", "dd", "address", "hr", "pre", "blockquote", "center",
        "a", "span", "bdo", "br", "em", "strong", "dfn", "code", "samp", "cite", "basefont",
        "font", "object", "param", "img", "table", "caption", "colgroup", "col", "thead", "tfoot", "tbody",
        "tr", "th", "td", "embed"]
    config.action_view.sanitized_allowed_attributes = ["id", "style", "href", "title", "target", "rel", "name",
        "class", "title", "src", "height", "alt", "width", "colspan", "rowspan", "headers", "scope", "span"]

    config.generators do |g|
      g.test_framework :rspec, spec: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.librarysearch_base_url = "https://#{ENV.fetch('LIBRARYSEARCH_DOMAIN', 'librarysearch.temple.edu')}"
    config.main_phone = "(215) 204-8212"
    config.search_books = "#{config.librarysearch_base_url}/books"
    config.search_articles = "#{config.librarysearch_base_url}/articles"
    config.search_databases = "#{config.librarysearch_base_url}/databases"
    config.search_everything = "#{config.librarysearch_base_url}/everything"
    config.librarysearch_finding_aids_url = "#{config.librarysearch_base_url}/web_content?f%5Bweb_content_type_facet%5D%5B%5D=Finding+Aids"
    config.primo_articles_url = "https://temple-primo.hosted.exlibrisgroup.com/primo-explore/citationlinker?vid=TULI"

    config.google_sheets_api_key = ENV["GOOGLE_SHEETS_API_KEY"]
    config.hours_spreadsheet_id = "1nZkmNzNwMsVlTa4sg3V1M1KOAvXcoyexLkeqTzqV_gs"
    config.hours_worksheet = "Sheet2"
    config.hours_spreadsheet_header_cells = "Sheet2!A1:O1"
    config.hours_spreadsheet_date_cells = "Sheet2!A2:A"
    config.google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]
    config.events_feed_url = ENV.fetch("EVENTS_FEED_URL", "https://events.temple.edu/feed/xml/events?department=2566")
    config.ensemble_api_user = ENV["ENSEMBLE_API_USER"]
    config.ensemble_api_key = ENV["ENSEMBLE_API_KEY"]

    config.draftable = ENV.fetch("MANIFOLD_DRAFTABLE", "false") == "true"
  end
end
