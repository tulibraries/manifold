# frozen_string_literal: true

class PolicySerializer < ApplicationSerializer
  include LinkSerializable
  include DescriptionSerializable

  attributes :name, :effective_date, :expiration_date
end
