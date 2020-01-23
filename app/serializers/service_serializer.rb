# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :title, :description, :access_description, :intended_audience
end
