# frozen_string_literal: true

require "json/ld"

module EventHelper
  def get_bldg_name(bldg_name)
    unless bldg_name.nil?
      t("manifold.default.event.#{bldg_name.parameterize.underscore}", default: bldg_name)
    end
  end

  def set_header(type, filter)
    case type
    when "dss_events"
      t("manifold.events.headings.dsc")
    when "hsl_events"
      t("manifold.events.headings.hsl")
    when "index"
      if filter.present? && filter == "events-only"
        t("manifold.events.headings.events")
      else
        t("manifold.events.headings.upcoming_events_workshops")
      end
    when "past_events"
      if filter.present? && filter == "events-only"
        t("manifold.events.headings.past_events")
      else
        t("manifold.events.headings.past_events_workshops")
      end
    when "workshops"
      t("manifold.events.headings.upcoming_workshops")
    when "past_workshops"
      t("manifold.events.headings.past_workshops")
    end
  end

  def filters_link(type)
    if type.present? && type.include?("past")
      (past_workshops_link(type) + " | " + past_events_link(type))
    else
      (workshops_link(type) + " | " + events_link(type))
    end
  end

  def workshops_link(type = "")
    if type == "dss_events" || type == "hsl_events"
      link_to t("manifold.events.index.view_all_workshops_link"), workshops_path(anchor: "list"), class: "workshops-link"
    else
      link_to t("manifold.events.index.view_workshops_link"), workshops_path(anchor: "list"), class: "workshops-link"
    end
  end

  def past_workshops_link(type)
    if type == "dss_events" || type == "hsl_events"
      link_to t("manifold.events.index.view_all_past_workshops_link"), past_workshops_path(anchor: "list"), class: "workshops-link"
    else
      link_to t("manifold.events.index.view_past_workshops_link"), past_workshops_path(anchor: "list"), class: "workshops-link"
    end
  end

  def events_link(type = "")
    if type == "dss_events" || type == "hsl_events"
      link_to t("manifold.events.index.view_all_events_link"), events_path(type: "events-only", anchor: "list"), class: "not-workshops-link"
    else
      link_to t("manifold.events.index.view_events_link"), events_path(type: "events-only", anchor: "list"), class: "not-workshops-link"
    end
  end

  def past_events_link(type)
    if type == "dss_events" || type == "hsl_events"
      link_to t("manifold.events.index.view_all_past_events_link"), past_events_path(type: "events-only", anchor: "list"), class: "not-workshops-link"
    else
      link_to t("manifold.events.index.view_past_events_link"), past_events_path(type: "events-only", anchor: "list"), class: "not-workshops-link"
    end
  end

  def current_link(type)
    type.include?("past") ?
      (link_to t("manifold.events.index.view_current_events"), events_path(anchor: "list"), class: "pe-4 current-events") :
      (link_to t("manifold.events.index.view_past_events"), past_events_path, class: "pe-4 past-events")
  end

  def close_button(type)
    case type
    when "past_events"
      link_to "X", past_events_path(anchor: "list"), class: "close-events-search"
    when "past_workshops"
      link_to "X", past_events_path(anchor: "list"), class: "close-events-search"
    when "past_search"
      link_to "X", past_events_path(anchor: "list"), class: "close-events-search"
    else
      link_to "X", events_path(anchor: "list"), class: "close-events-search" #, data: { "turbo-frame": "_top" }
    end
  end

  def display_date(date)
    Date.parse(date).strftime("%m-%d-%Y") if date.present?
  end
end
