class Space < ApplicationRecord
  include Validators

  validates :name, :description, :hours, :accessibility, :location, :image, presence: true
 	validates :email, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
 	validates :building_id, presence: true, valid_building_id: true
 	validates :parent_space_id, valid_space_id: true

  belongs_to :building
  belongs_to :parent_space, optional: true
end
