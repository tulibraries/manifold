# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable
  include AccessDescriptionSerializable

  attributes :title, :description, :access_description, :intended_audience
end
