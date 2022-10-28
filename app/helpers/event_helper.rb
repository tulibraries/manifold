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

  def workshops_link(type)
    unless params["type"].present?
      link_to "Limit to workshops", events_path(page: 1, type: "Workshop", anchor: "list"), class: "workshops-link d-block mt-4 roboto-light"
    end
  end

  def current_link(type)
    (type == "past" || type == "past_search") ?
      (link_to "View current events & exhibits", events_path, class: "pr-4") :
      (link_to "View past events & exhibits", past_events_path, class: "pr-4")
  end

  def events_title(type)
    case type
    when "search"
      t("manifold.events.index.page_title")
    when "past"
      "Past #{t("manifold.events.index.page_title")}"
    when "past_search"
      "Past #{t("manifold.events.index.page_title")}"
    else
      t("manifold.events.index.page_title")
    end
  end

  def close_button(type)
    case type
    when "past"
      link_to "X", past_events_path(anchor: "list"), class: "close-events-search"
    when "past_search"
      link_to "X", past_events_path(anchor: "list"), class: "close-events-search"
    else
      link_to "X", events_path(anchor: "list"), class: "close-events-search"
    end
  end

  def display_date(date)
    Date.parse(date).strftime("%m-%d-%Y") if date.present?
  end
end
