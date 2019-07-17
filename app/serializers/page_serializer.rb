# frozen_string_literal: true

class PageSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :title, :description, :layout
end
