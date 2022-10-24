# frozen_string_literal: true

require "json/ld"

module EventHelper
  def filter_tags_events
    tags = []
    unless params[:type].nil?
      types = params[:type].split(",")
      types.each do |type|
        tags << "#{type}&nbsp;<a href=\"#{events_path(request.query_parameters.except(:type).merge(page: 1))}\">X</a>"
      end
    end
    tags
  end

  def get_bldg_name(bldg_name)
    unless bldg_name.nil?
      t("manifold.default.event.#{bldg_name.parameterize.underscore}", default: bldg_name)
    end
  end

  def workshops_link
    if params["type"].present?
      if params["type"].downcase == "workshop"
        link_to "See all events", events_path, class: "workshops-link d-block mt-4 roboto-light"
      end
    else
      link_to "Limit to workshops", events_path(page: 1, type: "Workshop"), class: "workshops-link d-block mt-4 roboto-light"
    end
  end

  def display_date
    Date.parse(params[:date]).strftime("%m-%d-%Y") if params[:date].present?
  end
end
