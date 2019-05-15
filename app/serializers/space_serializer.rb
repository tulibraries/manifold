# frozen_string_literal: true

class SpaceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :hours, :accessibility, :phone_number, :email, :label
end
