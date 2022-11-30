# frozen_string_literal: true

require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Turn false under Spring and add config.action_view.cache_template_loading = true.
  config.cache_classes = true

  # Eager loading loads your whole application. When running a single test locally,
  # this probably isn't necessary. It's a good idea to do in a continuous integration
  # system, or in some way before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Hours Sync Test Sheet - So we can retrive test hours into the vcr_cassette
  config.hours_worksheet = "TESTING"
  config.hours_spreadsheet_header_cells = "TESTING!A1:O1"
  config.hours_spreadsheet_date_cells = "TESTING!A2:A"

  config.active_record.encryption.key_derivation_salt = "zQ6Q89VAOaJWYc8NrvEL6UHxZYrcIOim"
  config.active_record.encryption.deterministic_key = "AJsXfr2jM9eOmF4Q8nW7I9ZH2vhTjXH2"
  config.active_record.encryption.primary_key = "asj2kl2VsHSuoANX28kh8jRmsleGZw9r"

  config.active_record.use_yaml_unsafe_load = true
end

Rails.application.routes.default_url_options[:host] = "test.host"

## So we can test aws credential initializers
ENV["S3_ACCESS_KEY_ID"] = "access_key_id"
ENV["S3_SECRET_ACCESS_KEY"] = "secret_access_key"
ENV["S3_REGION"] = "region"
ENV["S3_BUCKET"] = "bucket"
ENV["LOCKBOX_MASTER_KEY"] = Lockbox.generate_key
