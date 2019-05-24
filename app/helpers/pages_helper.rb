# frozen_string_literal: true

module PagesHelper
  def navigation_items(page)
    nav_items = []
    @nav_items = []
    page.categories.each do |cat|
      cat.items.each do |item|
        unless item.id == page.id
          nav_items << "<li><a href=\"#{item}\">#{item.name}</a></li>"
        end
      end
    end
  end
end
