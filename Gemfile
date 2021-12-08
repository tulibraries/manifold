# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 6.1.4"
ruby "2.7.3"

gem "timecop"
gem "administrate", ">= 0.16.0"
gem "ancestry"
gem "attr_json"
gem "auto_strip_attributes"
gem "aws-sdk-s3"
gem "bootsnap", ">= 1.1.0", require: false
gem "bootstrap", "~> 4.6.1", "< 5.0.0"
gem "browser"
gem "cancancan", "~> 3.3"
gem "coffee-rails", "~> 4.2"
gem "devise"
gem "diffy"
gem "dotenv-rails"
gem "fast_jsonapi", "~> 1.0"
gem "feedjira"
gem "font-awesome-rails"
gem "fuzzy_match"
gem "google-analytics-rails", "1.1.1"
gem "google-api-client", "~> 0.53"
gem "honeybadger", "~> 4.9"
gem "httparty"
gem "jbuilder", "~> 2.11"
gem "jquery-rails"
gem "json-ld"
gem "kaminari"
gem "listen", ">= 3.0.5", "< 3.8"
gem "lockbox"
gem "mail_form"
gem "meta-tags"
gem "mini_magick", "~> 4.11"
gem "okcomputer"
gem "omniauth", "~> 2.0.4"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "paper_trail"
gem "pg"
gem "popper_js", "~> 1.16.0", "< 2.0.0"
gem "puma", "~> 5.5"
gem "rswag-api"
gem "rswag-ui"
gem "sass-rails", "~> 6.0"
gem "simple_form"
gem "sitemap_generator"
gem "skylight", "4.3.2"
gem "sqlite3", "~> 1.3.13"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "uglifier", ">= 1.3.0"
gem "yaml_db"
gem "friendly_id", "~> 5.4.2"
gem "action-draft"
gem "webpacker"
gem "image_processing", "~> 1.2"
gem "mimemagic", "0.4.3"
gem "active_storage_validations"

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
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15", "< 4.0"
  gem "chromedriver-helper"
  gem "factory_bot_rails", "~> 6.2.0"
  gem "guard-rspec", require: false
  gem "mutant-rspec"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec-rails", ">=3.8.0"
  gem "selenium-webdriver"
  gem "simplecov"
  gem "simplecov-lcov"
  gem "webmock"
  gem "launchy"
end
