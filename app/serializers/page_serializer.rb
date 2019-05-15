# frozen_string_literal: true

class PageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :layout, :label
end
