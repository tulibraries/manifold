# frozen_string_literal: true

require "json/ld"

module EventHelper
  def json_ld(event)
    input = JSON.parse event.to_json
    raw(input.to_json)
  end
end
