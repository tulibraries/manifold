# frozen_string_literal: true

class Occupant < ApplicationRecord
  belongs_to :space
  belongs_to :person
end
