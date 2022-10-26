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
      link_to "Limit to workshops", events_path(page: 1, type: "Workshop", anchor: "list"), class: "workshops-link d-block mt-4 roboto-light"
    end
  end

  def current_link?
    (action_name == "past" || action_name == "past_search") ?
      (link_to "View current events & exhibits", events_path, class: "pr-4") :
      (link_to "View past events & exhibits", past_events_path, class: "pr-4")
  end

  def events_title
    case action_name
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

  def close_button
    case action_name
    when "past"
      link_to "X", past_events_path, class: "close-events-search"
    when "past_search"
      link_to "X", past_events_path, class: "close-events-search"
    else
      link_to "X", events_path, class: "close-events-search"
    end
  end

  def display_date
    Date.parse(params[:date]).strftime("%m-%d-%Y") if params[:date].present?
  end
end
