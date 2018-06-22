class BuildingsPeople < ApplicationRecord
  belongs_to :building
  belongs_to :person
end
