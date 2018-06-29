class BuildingPerson < ApplicationRecord
  belongs_to :building
  belongs_to :person
end
