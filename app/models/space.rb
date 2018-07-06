class Space < ApplicationRecord
  include Validators
  has_ancestry

  validates :name, :description, :hours, :accessibility, :location, :image, presence: true
 	validates :email, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true

  belongs_to :building

  has_many :space_person
  has_many :persons, through: :space_person, source: :person

  has_many :space_group
  has_many :groups, through: :space_group, source: :group
end
