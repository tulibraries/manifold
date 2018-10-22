# frozen_string_literal: true

class Building < ApplicationRecord
  include Validators
  include InputCleaner

  validates :name, :address1, :address2, :temple_building_code, :coordinates, :google_id, :campus, presence: true
  validates :email, presence: true, email: true
  validates :phone_number, presence: true, phone_number: true
  validates :description, presence: true

  has_many :library_hours
  has_many :spaces

  has_one_attached :photo, dependent: :destroy

  auto_strip_attributes :email

  before_validation :normalize_phone_number
  before_validation :sanitize_description

  def todays_hours
    @today = Date.today.strftime("%Y-%m-%d 00:00:00")
    unless self.hours.blank?
      todays_hours = LibraryHours.where(location_id: self.hours, date: @today).pluck(:hours).first
    end
  end
end
