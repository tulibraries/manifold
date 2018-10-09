# frozen_string_literal: true

class SpaceGroup < ApplicationRecord
  belongs_to :space
  belongs_to :group
end
