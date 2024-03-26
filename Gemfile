# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 7.0.8.1"
gem "action-draft"
gem "active_storage_validations"
gem "activestorage-validator"
gem "administrate"
gem "administrate-field-active_storage"
gem "administrate-field-date_picker", "~> 0.3.0"
gem "administrate-field-ordered_has_many"
gem "administrate-field-scoped_has_many"
gem "ancestry"
gem "attr_json"
gem "auto_strip_attributes"
gem "aws-sdk-s3"
gem "base64", "0.2.0"
gem "bootsnap", require: false
gem "bootstrap"
gem "browser"
gem "cancancan", "~> 3.5"
gem "cssbundling-rails"
gem "database_cleaner"
gem "devise"
gem "diffy"
gem "dotenv-rails"
gem "fast_jsonapi", "~> 1.0"
gem "feedjira"
gem "friendly_id"
gem "fuzzy_match"
gem "google-apis-sheets_v4"
gem "honeybadger", "~> 5.8"
gem "httparty"
gem "image_processing", "~> 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "json-ld", ">= 3.3.1"
gem "kaminari"
gem "listen", ">= 3.0.5", "< 3.10"
gem "lockbox"
gem "mail_form"
gem "meta-tags"
gem "mimemagic", "0.4.3"
gem "mini_magick"
gem "nokogiri", "1.16.3"
gem "okcomputer"
gem "omniauth", "~> 2.1.2"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "orderly"
gem "paper_trail", git: "https://github.com/paper-trail-gem/paper_trail"
gem "pg"
gem "pg_search"
gem "puma", "~> 6.4.2"
gem "rswag-api"
gem "rswag-ui"
gem "simple_form"
gem "sitemap_generator"
gem "sprockets-rails"
gem "stimulus-rails"
gem "timecop"
gem "turbo-rails"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "view_component"
gem "yaml_db"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "json-schema"
  gem "pry-rails"
  gem "pry-byebug"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
  gem "vcr"
end

group :development do
  gem "brakeman"
  gem "faker"
  gem "populate"
  gem "rails-erd"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.1.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "factory_bot_rails"
  gem "guard-rspec", require: false
  gem "mutant-rspec"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "webmock"
  gem "launchy"
  gem "shoulda-matchers", "~> 6.2"
end

group :production do
  gem "dalli"
  gem "connection_pool"
end
