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
end
