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
end
