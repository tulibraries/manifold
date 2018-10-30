# frozen_string_literal: true

class BuildingPolicy < ApplicationRecord
  belongs_to :building
  belongs_to :policy
end
