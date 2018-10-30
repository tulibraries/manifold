# frozen_string_literal: true

class SpacePolicy < ApplicationRecord
  belongs_to :space
  belongs_to :policy
end
