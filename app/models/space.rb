class Space < ApplicationRecord
  include Validators
  has_ancestry

  validates :name, :description, :hours, :accessibility, :image, presence: true
 	validates :email, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
  validates :building_id, presence: true

  auto_strip_attributes :email

  belongs_to :building

  has_many :occupant
  has_many :persons, through: :occupant, source: :person

  has_many :space_group
  has_many :groups, through: :space_group, source: :group
end
