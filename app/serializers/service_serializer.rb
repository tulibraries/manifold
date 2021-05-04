# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable
  include AccessDescriptionSerializable

  attributes :title, :intended_audience
end
