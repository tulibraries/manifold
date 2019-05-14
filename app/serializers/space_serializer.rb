# frozen_string_literal: true

class SpaceSerializer < ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :hours, :accessibility, :phone_number, :email
end
