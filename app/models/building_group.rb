class BuildingGroup < ApplicationRecord
  belongs_to :building
  belongs_to :group
end
