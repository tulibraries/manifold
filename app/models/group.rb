# frozen_string_literal: true

class Group < ApplicationRecord
  include Validators
  include InputCleaner

  auto_strip_attributes :email_address  # Auto strip must occur prior to validates

  validates :name, :spaces, :chair_dept_head, presence: true
  validates :email_address, presence: true, email: true
  validates :phone_number, presence: true, phone_number: true
  validates :group_type, presence: true, group_type: true

  before_validation :sanitize_description

  has_many_attached :documents, dependent: :destroy

  has_many :member
  has_many :persons, through: :member, source: :person

  has_many :space_group
  has_many :spaces, through: :space_group, source: :space

  has_one :group_contact
  has_one :chair_dept_head, through: :group_contact, source: :person

  has_many :service_group
  has_many :related_services, through: :service_group, source: :service


    def todays_date
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
      @today.to_date.strftime("%^A, %^B %d, %Y ")
    end
    def todays_hours
      @today = Date.today.strftime("%Y-%m-%d 00:00:00")
      unless self.spaces.first.hours.blank? 
        todays_hours = LibraryHours.where(location_id: self.spaces.first.hours, date: @today)
        todays_hours.first.hours
      else
        unless self.spaces.first.building.hours.blank?
          todays_hours = LibraryHours.where(location_id: self.spaces.first.building.hours, date: @today)
          todays_hours.first.hours
        end
      end
    end

end
