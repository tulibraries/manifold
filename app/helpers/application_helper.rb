# frozen_string_literal: true

module ApplicationHelper
  def render_map(name, coordinates, google_id)
    link_to image_tag("https://maps.googleapis.com/maps/api/staticmap?center=#{coordinates}&zoom=15&size=520x520&markers=size:mid%7Ccolor:red%7Clabel:%7C#{coordinates}&key=#{Rails.configuration.google_maps_api_key}", alt: "Google Map of #{name}", class: "map"),
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
    if item.is_a?(Category)
      list = '<ul class="list-unstyled">'
      item.items.each do |page|
        list += "<li>#{link_to page.label, url_for(page), style: "color: black"}</li>"
      end
      list += "</ul>"
    else
      ""
    end
  end
end
