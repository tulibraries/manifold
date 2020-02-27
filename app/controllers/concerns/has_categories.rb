# frozen_string_literal: true

module HasCategories
  extend ActiveSupport::Concern

  def cat_link(cat, dog)
    links = []
    cat.items(exclude: [:category]).each do |c|
      unless c == dog
        link = "<li>"
      else
        link = '<li class="selected">'
      end
      link += '<a href="' + url_for(c) + '">' + c.label + "</a></li>"
      links << link
    end
    links
  end

  protected

    def url_for(options = {})
      obj = options[:slug]
      options[:slug] = obj
      super(options)
    end
end
