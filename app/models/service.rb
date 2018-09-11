class Service < ApplicationRecord
  validates :title, :description, :intended_audience, :service_category, presence: true
  validates :related_groups, presence: true

  has_many :service_space
  has_many :related_spaces, through: :service_space, source: :space

  has_many :service_group
  has_many :related_groups, through: :service_group, source: :group
end
