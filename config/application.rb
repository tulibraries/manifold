# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tude
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.tinymce.install

    config.generators do |g|
      g.test_framework :rspec, spec: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.group_types = ["Assembly",
                          "Committee",
                          "Department",
                          "Functional Team",
                          "Strategic Steering Team",
                          "Working Group"]

    config.highlight_types = ["DSC Event",
                              "Featured Staff",
                              "Featured Resource",
                              "Featured Location",
                              "HSL Highlight",
                              "Program/Event",
                              "Staff Recommendation"]

    config.service_types = ["Access to collections & resource sharing",
                            "Building & space use",
                            "Digital scholarship",
                            "Publishing Services",
                            "Research & instruction support",
                            "Research data services",
                            "Scholarly communication",
                            "Technology use & support"]

    config.audience_types = ["Alumni",
                             "Continuing education students",
                             "Faculty",
                             "Graduate students",
                             "Instructors",
                             "Non-credit students",
                             "Pennsylvania residents",
                             "Students w/ disabilities",
                             "Temple University Hospital employees",
                             "Temple University Hospital residents",
                             "Undergraduate students",
                             "University staff & administration",
                             "Visitors & community members",
                             "Visiting scholars"]

    config.specialties = [  "Advertising",
                            "Africology & African-American Studies",
                            "American Studies",
                            "Anthropology",
                            "Architecture",
                            "Art",
                            "Art Education",
                            "Art History",
                            "Asian Studies",
                            "Bioengineering",
                            "Biology",
                            "Biomedical Science",
                            "Business",
                            "Chemistry",
                            "Civil & Environmental Engineering",
                            "Classics",
                            "Communication & Social Influence",
                            "Communication Management",
                            "Communication Sciences & Disorders",
                            "Communication Studies",
                            "Computer & Information Sciences",
                            "Criminal Justice",
                            "Dance",
                            "Dentistry",
                            "Earth & Environmental Science",
                            "Economics",
                            "Education",
                            "Electrical & Computer Engineering",
                            "English",
                            "Environmental Studies",
                            "FIlm & Media Arts",
                            "Gender, Sexuality & Women's Studies",
                            "Geographic Information Systems (GIS)",
                            "Geography & Urban Studies",
                            "German",
                            "Global Studies",
                            "Government Information",
                            "History",
                            "Horticulture",
                            "Jewish Studies",
                            "Journalism",
                            "Kinesiology",
                            "Landscape Architecture",
                            "Latin American Studies",
                            "Law",
                            "LGBT Studies",
                            "Mathematics",
                            "Mechanical Engineering",
                            "Media Studies & Production",
                            "Medicine",
                            "Music",
                            "Music Education",
                            "Music Therapy",
                            "Neuroscience",
                            "Nursing",
                            "Pharmacy",
                            "Philosophy",
                            "Physical Therapy",
                            "Physician Assistant",
                            "Physics",
                            "Planning & Community Development",
                            "Podiatric Medicine",
                            "Political Science",
                            "Portuguese",
                            "Postbaccalaureate Pre-Health",
                            "Postbaccalaureate Pre-Med",
                            "Psychology",
                            "Public Health",
                            "Public Policy",
                            "Public Relations",
                            "Rehabilitation Sciences",
                            "Religion",
                            "Social Work",
                            "Sociology",
                            "Spanish",
                            "Sport, Tourism & Hospitality Management",
                            "Theater",
                            "Urban Bioethics",
                            ]

    config.google_sheets_api_key = ENV["GOOGLE_SHEETS_API_KEY"]
    config.google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]
    config.events_feed_url = ENV.fetch("EVENTS_FEED_URL", "https://events.temple.edu/feed/xml/events?department=2566")
  end
end
