class Space < ApplicationRecord
  include Validators
  include InputCleaner
  has_ancestry

  validates :name, presence: true
  # TODO implement: validates :description, presence: true
 	validates :email, email: true
 	validates :phone_number, phone_number: true
  validates :building_id, presence: true

  before_validation :sanitize_description

  auto_strip_attributes :email

  has_one_attached :photo, dependent: :destroy

  before_validation :normalize_phone_number

  belongs_to :building

  has_many :occupant
  has_many :persons, through: :occupant, source: :person

  has_many :space_group
  has_many :groups, through: :space_group, source: :group
end
