# frozen_string_literal: true

class Occupant < ApplicationRecord
  belongs_to :building
  belongs_to :person
end
