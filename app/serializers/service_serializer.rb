# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :title, :access_description, :intended_audience
end
