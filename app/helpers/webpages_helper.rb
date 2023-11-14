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

  def blog_name(id)
    Blog.find(id).title
  end
  def blog_url(id)
    Blog.find(id).base_url
  end
  def get_tags(tags)
    new_tags = []
    old_tags = tags.split(",")
    old_tags.reject { |tag| tag == "Uncategorized" }.each do |tag|
      new_tags.push([tag.gsub(/\s+/, ""), tag])
    end
    new_tags
  end

  def etextbooks_snippet
    intro = Snippet.find_by(slug: t("manifold.webpages.etextbooks.slug"))
    title = nil
    description = nil
    if intro.present?
      title = intro.title
      description = intro.description
    end
    { title:, description: }
  end
end
