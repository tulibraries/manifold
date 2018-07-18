class Person < ApplicationRecord
  include Validators

  validates :first_name, :last_name, :chat_handle, :job_title, :identifier, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
 	validates :spaces, presence: true

  has_many :group_person
  has_many :groups, through: :group_person, source: :group

  has_many :space_person
  has_many :spaces, through: :space_person, source: :space
end
