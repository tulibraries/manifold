# frozen_string_literal: true

module WebpagesHelper
  def attachment_title(title)
    (title.include? "Speaking Volumes ") ? title.gsub("Speaking Volumes ", "") : title
  end
  def phone_icon
    image_tag("phone-handle.png", class: "category-icon decorative")
  end

  def text_icon
    image_tag "mobile-text.png", class: "category-icon decorative"
  end

  def render_as_phone_link_on_mobile(number:, link_content: nil, type: "tel")
    content = link_content || number
    browser.device.mobile? ? link_to(content, "#{type}:#{number}") : content
  end

  def render_as_sms_link_on_mobile(number:, link_content: nil)
    render_as_phone_link_on_mobile(
      number:,
      link_content:,
      type: "sms"
    )
  end

  def navigation_items(page)
    nav_items = []
    page.categories.each do |cat|
      cat.items.each do |item|
        unless item.id == page.id
          nav_items << "<li><a href=\"#{item}\">#{item.name}</a></li>"
        end
      end
    end
  end
end
