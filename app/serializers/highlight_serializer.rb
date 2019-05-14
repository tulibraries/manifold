# frozen_string_literal: true

class HighlightSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :blurb, :link, :type_of_highlight, :tags, :promoted, :link_label
end
