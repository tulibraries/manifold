# frozen_string_literal: true

module ApplicationHelper
  def render_map(name, coordinates, google_id)
    link_to image_tag("https://maps.googleapis.com/maps/api/staticmap?center=#{coordinates}&zoom=15&size=420x275&markers=size:mid%7Ccolor:red%7Clabel:%7C#{coordinates}&key=#{Rails.configuration.google_maps_api_key}", alt: "Google Map of #{name}", class: "map"),
    "https://www.google.com/maps/search/?api=1&query=#{coordinates}&query_place_id=#{google_id}"
  end
end
