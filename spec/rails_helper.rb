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
require "base64"


Capybara.app_host = "http://localhost:3000"
Capybara.server_host = "localhost"
Capybara.server_port = "3000"

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
  config.include Rails.application.routes.url_helpers
  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Capybara::DSL

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [Rails.root.join("spec/fixtures")]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.``
  config.use_transactional_fixtures = true

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
        body: File.open("#{fixture_paths[0]}/charles.jpg"), headers: {}
      )

    stub_request(:get, "https://example.com/noimage.jpg").
      to_return(status: 403, body: "Nope", headers: {})


    stub_request(:get, "https://sites.temple.edu/devopsing/feed").
      to_return(status: 200, body: File.open("#{fixture_paths[0]}/blog_posts.rss") , headers: {})

    stub_request(:put, "https://bucket.s3.region.amazonaws.com/cache/sitemap.xml.gz").
      to_return(status: 200, body: "", headers: {})



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
    c.filter_sensitive_data("<gsheets_key>") { ENV["GOOGLE_SHEETS_API_KEY"] }
    c.default_cassette_options = {
      match_requests_on: [:method, VCR.request_matchers.uri_without_param(:key)],
      erb: true
    }
    c.hook_into :webmock
    c.configure_rspec_metadata!
    c.filter_sensitive_data("<key>") { ENV["PANOPTO_API_USER"] }
    c.filter_sensitive_data("<code>") { ENV["PANOPTO_API_KEY"] }
    auth_string = ENV["PANOPTO_API_USER"].to_s + ":" + ENV["PANOPTO_API_KEY"].to_s
    c.filter_sensitive_data("<base64_key_code>") { Base64.encode64(auth_string) }

    # Ignore Selenium WebDriver and Capybara server requests
    c.ignore_request do |request|
      # Ignore requests to localhost (Capybara server)
      URI(request.uri).host == "127.0.0.1" || URI(request.uri).host == "localhost"
    end
  end

  config.include ActionText::SystemTestHelper, type: :system

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
