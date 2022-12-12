# frozen_string_literal: true

require "json/ld"

module EventHelper
  def get_bldg_name(bldg_name)
    unless bldg_name.nil?
      t("manifold.default.event.#{bldg_name.parameterize.underscore}", default: bldg_name)
    end
  end

  def workshops_link(type)
    if type.blank?
      action_name == "past" ?
        (link_to "Limit to workshops", past_events_path(page: 1, type: "Workshop", anchor: "list"), class: "workshops-link d-block mt-4 mb-2 roboto-light")
        :
        (link_to "Limit to workshops", events_path(page: 1, type: "Workshop", anchor: "list"), class: "workshops-link d-block mt-4 mb-2 roboto-light")
    else
      if type == "dss_events"
        link_to "View all workshops", events_path(page: 1, type: "Workshop", anchor: "list"), class: "workshops-link d-block mt-4 mb-2 roboto-light"
      end
    end
  end

  def current_link(type)
    type == "past_search" ?
      (link_to "View current events & exhibits", events_path, class: "pe-4 current-events") :
      (link_to "View past events & exhibits", past_events_path, class: "pe-4 past-events")
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
