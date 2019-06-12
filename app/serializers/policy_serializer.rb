# frozen_string_literal: true

class PolicySerializer < ApplicationSerializer
  attributes :name, :description, :effective_date, :expiration_date, :category
end
