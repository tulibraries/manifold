class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class PhoneNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\d{10}/i
      record.errors[attribute] << (options[:message] || "is not a telephone number")
    end
  end
end

class Building < ApplicationRecord
  validates :name, :description, :address1, :temple_building_code, :directions_map, :hours, :image, :campus, :accessibility, presence: true
	validates :email, presence: true, email: true
	validates :phone_number, presence: true, phone_number: true
end
