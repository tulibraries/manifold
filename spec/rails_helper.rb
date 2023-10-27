# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "view_component/test_helpers"
require "view_component/system_test_helpers"
require "capybara/rspec"
require "capybara/rails"
require "action_text/system_test_helper"
# require "paper_trail/frameworks/rspec"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

include Warden::Test::Helpers


# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.

begin
  ActiveRecord::Migration.maintain_test_schema!
  rescue ActiveRecord::PendingMigrationError => e
    abort e.to_s.strip
end

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = Rails.root.join("spec/fixtures")

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.``
  config.use_transactional_fixtures = true

  config.before(:suite) do
    # if config.use_transactional_fixtures?
    #   raise(<<-MSG)
    #     Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
    #     (or set it to false) to prevent uncommitted transactions being used in
    #     JavaScript-dependent specs.

    #     During testing, the app-under-test that the browser driver connects to
    #     uses a different database connection than the database connection used by
    #     the spec. The app's database connection would not be able to access
    #     uncommitted transaction data setup over the spec's database connection.
    #   MSG
    # end
    DatabaseCleaner.clean_with(:transaction)
  end

  config.after(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # :rack_test driver's Rack app under test shares database connection
    # with the specs, so continue to use transaction strategy for speed.
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    unless driver_shares_db_connection_with_specs
      # Driver is probably for an external browser with an app
      # under test that does *not* share a database connection with the
      # specs, so use truncation strategy.
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Allow log in in request specs
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller


  config.before(:each) do
    stub_request(:get, /.*events\.temple\.edu\/.*\.jpg.*/im)
      .to_return(
        status: 200,
        body: File.open("#{fixture_path}/charles.jpg"), headers: {}
      )

    stub_request(:get, "https://example.com/noimage.jpg").
      to_return(status: 403, body: "Nope", headers: {})


    stub_request(:get, "https://sites.temple.edu/devopsing/feed").
      to_return(status: 200, body: File.open("#{fixture_path}/blog_posts.rss") , headers: {})

    stub_request(:put, "https://bucket.s3.region.amazonaws.com/sitemap.xml.gz").
      to_return(status: 200, body: File.open("#{fixture_path}/vcr_cassettes/etexts.yml"), headers: {})

    stub_request(:get, "https://sheets.googleapis.com/v4/spreadsheets/1rWlXEp_EPYSyTHaUMkmTH1IyJqHSX9yXy8MR5sxNuvU/values/Sheet1!A2:G").
      to_return(status: 200)

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/98a7258a-f81f-48c1-8541-af1900e5a7af/sessions/").
         with(
           headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
           }).
         to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/eba32425-d6bf-4e9c-983f-af1f0128b62b/sessions/").
        with(
          headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
          }).
        to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/e01cdfba-bc19-4f27-bdc6-af1c00f52773/sessions/").
          with(
            headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
            }).
          to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/1aab1d3f-4626-43fd-924d-af1c00f290d5/sessions/").
        with(
          headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
          }).
        to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/ad6a8ada-242e-4ddd-8115-af1c00fc3621/sessions/").
        with(
          headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Authorization" => "Bearer",
        "User-Agent" => "Ruby"
          }).
        to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/d320fce9-a51c-4e6f-b85a-af1901046d79/sessions/").
        with(
          headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
          }).
        to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})

    stub_request(:get, "https://temple.hosted.panopto.com/Panopto/api/v1/playlists/980a89be-5d85-43e2-b171-af1c00fdd352/sessions/").
          with(
            headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Authorization" => "Bearer",
          "User-Agent" => "Ruby"
            }).
          to_return(status: 200, body: file_fixture("recent-videos.json").read, headers: {})
  end

  VCR.configure do |c|
    c.cassette_library_dir = "spec/fixtures/vcr_cassettes"
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.filter_sensitive_data("<key>") { ENV["PANOPTO_API_USER"] }
    c.filter_sensitive_data("<code>") { ENV["PANOPTO_API_KEY"] }
    c.filter_sensitive_data("<gsheets_key>") { ENV["GOOGLE_SHEETS_API_KEY"] }
  end

  config.include ActionText::SystemTestHelper, type: :system

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
