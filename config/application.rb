# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Manifold
  class Application < Rails::Application
    config.time_zone = "Eastern Time (US & Canada)"
    config.load_defaults 7.0
    config.active_storage.variant_processor = :mini_magick
    config.exceptions_app = self.routes
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
    config.search_articles = "#{config.librarysearch_base_url}/articles"
    config.search_books = "#{config.librarysearch_base_url}/books"
    config.search_catalog = "#{config.librarysearch_base_url}/catalog"
    config.search_databases = "#{config.librarysearch_base_url}/databases"
    config.search_everything = "#{config.librarysearch_base_url}/everything"
    config.librarysearch_finding_aids_url = "#{config.librarysearch_base_url}/web_content?f%5Bweb_content_type_facet%5D%5B%5D=Finding+Aids"
    config.primo_articles_url = "https://temple-primo.hosted.exlibrisgroup.com/primo-explore/citationlinker?vid=TULI"

    config.google_sheets_api_key = ENV["GOOGLE_SHEETS_API_KEY"]

    config.hours_spreadsheet_id = "1IXyE2EgREGvxpVBz_qcDlQovQ-w3BJOgUCfwz8bBtqI"
    config.hours_spreadsheet_date_cells = "A2:R"
    config.hours_worksheet = "HOURS"
    config.hours_today = "today!A2:A2"
    config.hours_worksheet_date_column = "A2:A"
    config.hours_worksheet_charles = "B2:B"
    config.hours_worksheet_service_zone = "C2:C"
    config.hours_worksheet_cafe = "D2:D"
    config.hours_worksheet_scrc = "E2:E"
    config.hours_worksheet_scholars_studio = "F2:F"
    config.hours_worksheet_success_center = "G2:G"
    config.hours_worksheet_ask_a_librarian = "H2:H"
    config.hours_worksheet_asrs = "I2:I"
    config.hours_worksheet_guest_computers = "J2:J"
    config.hours_worksheet_blockson = "K2:K"
    config.hours_worksheet_ambler = "L2:L"
    config.hours_worksheet_ginsburg = "M2:M"
    config.hours_worksheet_podiatry = "N2:N"
    config.hours_worksheet_innovation = "O2:O"
    config.hours_worksheet_24_7 = "P2:P"
    config.hours_worksheet_exhibits = "R2:R"

    config.etexts_spreadsheet_id = "1rWlXEp_EPYSyTHaUMkmTH1IyJqHSX9yXy8MR5sxNuvU"
    config.etexts_spreadsheet_etext_cells = "Sheet1!A2:G"

    config.google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]
    config.events_feed_url = ENV.fetch("EVENTS_FEED_URL", "https://events.temple.edu/feed/xml/events?department=2566")
    config.ensemble_api_user = ENV["ENSEMBLE_API_USER"]

    config.ensemble_api_key = ENV["ENSEMBLE_API_KEY"]

    config.draftable = ENV.fetch("MANIFOLD_DRAFTABLE", "false") == "true"
    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]
    config.sync_timeout = ENV.fetch("MANIFOLD_SYNC_TIMEOUT", "180").to_i

    # temporary Link Exchanger redirects
    config.link_exchange = config_for(:link_exchange)
  end
end
