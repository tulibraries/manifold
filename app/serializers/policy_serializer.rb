# frozen_string_literal: true

class PolicySerializer < ApplicationSerializer
  include LinkSerializable

  attributes :name, :description, :effective_date, :expiration_date
end
