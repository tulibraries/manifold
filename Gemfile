# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "3.1.3"

gem "rails", "~> 7.0.4.1"
gem "action-draft"
gem "active_storage_validations"
gem "activestorage-validator"
gem "administrate", "~> 0.17.0"
gem "administrate-field-date_picker", "~> 0.3.0"
gem "administrate-field-ordered_has_many"
gem "administrate-field-scoped_has_many"
gem "ancestry"
gem "attr_json"
gem "auto_strip_attributes"
gem "aws-sdk-s3"
gem "bootsnap", require: false
gem "bootstrap"
gem "browser"
gem "cancancan", "~> 3.4"
gem "cssbundling-rails"
gem "devise"
gem "diffy"
gem "dotenv-rails"
gem "fast_jsonapi", "~> 1.0"
gem "feedjira"
gem "friendly_id"
gem "fuzzy_match"
gem "google-analytics-rails", "1.1.1"
gem "google-api-client", "~> 0.53"
gem "honeybadger", "~> 5.1"
gem "httparty"
gem "image_processing", "~> 1.2"
gem "jbuilder"
gem "jsbundling-rails"
gem "json-ld"
gem "kaminari"
gem "listen", ">= 3.0.5", "< 3.9"
gem "lockbox"
gem "mail_form"
gem "meta-tags"
gem "mimemagic", "0.4.3"
gem "mini_magick"
gem "nokogiri", "1.14.1"
gem "okcomputer"
gem "omniauth", "~> 2.1.1"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paper_trail", git: "https://github.com/paper-trail-gem/paper_trail"
gem "pg"
gem "puma", "~> 6.0.2"
gem "rswag-api"
gem "rswag-ui"
gem "simple_form"
gem "sitemap_generator"
gem "skylight", "4.3.2"
gem "sprockets-rails"
gem "stimulus-rails"
gem "timecop"
gem "turbo-rails"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
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
  gem "shoulda-matchers", "~> 5.2"
end
