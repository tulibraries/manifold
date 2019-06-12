# frozen_string_literal: true

class SpaceSerializer < ApplicationSerializer
  attributes :name, :description, :hours, :accessibility, :phone_number, :email
end
