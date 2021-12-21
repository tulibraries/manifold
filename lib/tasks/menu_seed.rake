# frozen_string_literal: true

require "logger"

namespace :deseed do
  task menus: [:environment] do

    @log = Logger.new("log/menus-deseeded.log")
    @stdout = Logger.new(STDOUT)
    stdout_and_log("Re-initializes deleted top-level categories and reassigns categories from MenuGroups")

    categories = Category.create([{ name: "About", slug: "about-page" },
                              { name: "Visit", slug: "visit" },
                              { name: "Research Services", slug: "research-services" }])

    categories.each do |category|
      # remove categories inadvertantly assigned
      category.categories.each do |cat|
        category.categories.delete(cat)
      end if category.categories.any?

      oldgroup = MenuGroup.find_by(slug: category.slug)

      # add categories from menugroups as categorizations
      oldgroup.categories.each do |item|
        category.categorizations << item if item.is_a?(Category)
      end
      category.save!
      stdout_and_log("Saved: #{category.name} category, categories: #{category.categorizations}")
    end

    # MenuGroup.destroy(MenuGroup.find_by(slug: "about-page").id)
    # MenuGroup.destroy(MenuGroup.find_by(slug: "visit").id)
    # MenuGroup.destroy(MenuGroup.find_by(slug: "research-services").id)
  end
end

def stdout_and_log(message, level: :info)
  @log.send(level, message)
  @stdout.send(level, message)
end
