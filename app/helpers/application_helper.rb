# frozen_string_literal: true

module ApplicationHelper
  def image_alt_text(model)
    if model.class.name == "Event"
      model.alt_text.presence || nil
    else
      model.image_alt_text.presence || nil
    end
  end

  def get_season
    today = Time.zone.today
    case today.month
    when 1
      "winter"
    when 2
      "winter"
    when 3
      if today.day <= 20
        "winter"
      else
        "spring"
      end
    when 4
      "spring"
    when 5
      "spring"
    when 6
      if today.day <= 20
        "spring"
      else
        "summer"
      end
    when 7
      "summer"
    when 8
      "summer"
    when 9
      if today.day <= 20
        "summer"
      else
        "fall"
      end
    when 10
      "fall"
    when 11
      "fall"
    when 12
      if today.day <= 20
        "fall"
      else
        "winter"
      end
    end
  end

  def render_map(name, coordinates, google_id)
    link_to image_tag("https://maps.googleapis.com/maps/api/staticmap?center=#{coordinates}&zoom=15&size=1096x730&markers=size:mid%7Ccolor:red%7Clabel:%7C#{coordinates}&key=#{Rails.configuration.google_maps_api_key}", alt: "Google Map of #{name}", class: "map"),
    "https://www.google.com/maps/search/?api=1&query=#{coordinates}&query_place_id=#{google_id}"
  end

  def menu_category_list(categories)
    categories.collect(&:label).join(" and ")
  end

  def librarysearch_url(type = nil)
    if type.nil?
      Rails.configuration.librarysearch_base_url
    else
      Rails.configuration.librarysearch_base_url + "/" + type
    end
  end

  def json_ld(entity)
    raw(entity.map_to_schema_dot_org.to_json)
  end

  def edit_url
    path = request.env["PATH_INFO"]
    controller = path.split("/").slice(1)
    id = path.split("/").slice(2)
    exemptions = [nil, "library_hours", "webpages"]

    controller == "libraries" ? controller = "buildings" : controller = controller_name

    unless exemptions.include?(controller)
      "/admin/#{controller}/#{id}?admin=show"
    else
      if controller == "webpages" && action_name == "show"
        "/admin/#{controller}/#{id}?admin=show"
      else
        "/admin/#{controller}?admin=index"
      end
    end
  end

  def get_item_list(item)
    if item.items.count > 0
      list = "<h1 class=\"menu-category mr-4 pb-3\">#{link_to item.label, item}"
      list += "<span>#{item.description}</span>"
      list += "</h1>"
      list += '<ul class="list-unstyled menu-items">'
      item.items.each do |page|
        list += "<li class=\"mt-0\">#{link_to page.label, url_for(page)}</li>"
      end
      list += "</ul>"
    else
      ""
    end
  end

  def get_items(category)
    if  category&.items && category.items.count > 0
      list = "<h1 class=\"menu-category mr-4 pb-3\">#{link_to category.name, category}"
      list += "<span>#{category.description}</span>"
      list += "</h1>"
      list += '<ul class="list-unstyled menu-items">'
      category.items.each do |page|
        list += "<li class=\"mt-0\">#{link_to page.label, url_for(page)}</li>"
      end
      list += "</ul>"
    else
      ""
    end
  end
end
