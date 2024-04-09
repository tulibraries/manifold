# frozen_string_literal: true

module HasCategories
  extend ActiveSupport::Concern

  def cat_link(category, model_instance)
    links = []
    category.items(exclude: [:category]).each do |item|
      unless item == model_instance
        link = "<li>"
      else
        link = '<li class="selected">'
      end
      link += '<a href="' + get_link(item) + '">' + item.label + "</a></li>"
      links << link
    end
    links
  end

  protected

    def get_link(options = {})
      obj = options[:slug]
      options[:slug] = obj
      url_for(options)
    end
end
