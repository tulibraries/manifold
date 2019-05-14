# frozen_string_literal: true

class PageSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :description, :layout
end
