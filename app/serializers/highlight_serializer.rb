# frozen_string_literal: true

class HighlightSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :blurb, :link, :type_of_highlight, :tags, :promoted, :link_label, :label
end
