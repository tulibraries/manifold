# frozen_string_literal: true

require "logger"

namespace :seed do
  task menus: [:environment] do

    @log = Logger.new("log/menu-seeds.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Initializes main menu groups and adds existing categories")

    menus = MenuGroup.create([{ title: "About", slug: "about-page" },
                              { title: "Visit", slug: "visit" },
                              { title: "Research Services", slug: "research-services" }])

    menus.each do |menu|
      oldgroup = Category.find_by(slug: menu.slug)
      oldgroup.items.each do |item|
        menu.categories << item if item.is_a?(Category)
      end
      menu.save!
      stdout_and_log("Saved: #{menu} menu, categories: #{menu.categories}")
    end

    Category.destroy(Category.find_by(slug: 'about-page').id)
    Category.destroy(Category.find_by(slug: 'visit').id)
    Category.destroy(Category.find_by(slug: 'research-services').id)
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
