class Space < ApplicationRecord
  validates :name, :description, :hours, :accessibility, :location, :image, presence: true
#	validates :email, presence: true, email: true
#	validates :phone_number, presence: true, phone_number: true

  belongs_to :building
  belongs_to :space
end
