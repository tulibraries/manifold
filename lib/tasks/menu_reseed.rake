# frozen_string_literal: true

require "logger"

namespace :reseed do
  task menus: [:environment] do

    @log = Logger.new("log/main-menu-reseed.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Re-initializes top-level categories as MenuGroups with assigned categories after schema adjust removes them")

    @about_page = ["Welcome",
      "Reports & Statistics",
      "Support the Libraries",
      "Policies & Guidelines",
      "Blogs & News"]

    @visit = ["Temple Libraries & Locations",
      "Study Spaces",
      "Borrowing",
      "Computers, Printing & Technology",
      "Charles Library Public Spaces",
      "Visitor & Alumni Access",
      "Access and services during COVID-19",
      "Events, Exhibits & Workshops",
      "Explore Charles Library"]

    @research_services = [ "Get Started",
      "Support for Instructors",
      "Support for Researchers",
      "Collections",
      "Textbook Affordability Project",
      "Research Data Services",
      "TUScholarShare",
      "Publishing Services",
      "Grants, Fellowships & Competitions",
      "Library Workshops"]

    MenuGroup.all.each do |menu|
      case menu.slug
      when "about-page"
        assign_categories(menu, @about_page)
      when "visit"
        assign_categories(menu, @visit)
      when "research-services"
        assign_categories(menu, @research_services)
      end
    end
  end
end

def assign_categories(menu_group, categories)
  categories.each do |category|
    menu_group.categories << Category.find_by(name: category)
  end
  menu_group.save!
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
