class Occupant < ApplicationRecord
  belongs_to :space
  belongs_to :person
end
