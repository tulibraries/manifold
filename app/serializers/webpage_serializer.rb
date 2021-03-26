# frozen_string_literal: true

class WebpageSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :title, :layout
end
