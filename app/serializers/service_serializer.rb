# frozen_string_literal: true

class ServiceSerializer < ApplicationSerializer
  include LinkSerializable

  attributes :title, :description, :access_description, :service_policies,
    :intended_audience
end
