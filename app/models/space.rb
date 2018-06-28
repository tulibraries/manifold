class Space < ApplicationRecord
  include Validators

  validates :name, :description, :hours, :accessibility, :location, :image, presence: true
 	validates :email, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true

  belongs_to :building
  has_and_belongs_to_many :parent_space, optional: true

  has_many :spaces_people, class_name: "SpacesPeople"
  has_many :persons, through: :spaces_people

  has_many :spaces_groups, class_name: "SpacesGroups"
  has_many :groups, through: :spaces_groups
end
