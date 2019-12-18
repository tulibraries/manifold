# frozen_string_literal: true

class WebpageSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :title, :description, :layout
end
