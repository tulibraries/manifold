class Person < ApplicationRecord
  include Validators

  validates :first_name, :last_name, :chat_handle, :job_title, :identifier, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
	validates :building_id, presence: true, valid_building_id: true
	validates :space_id, valid_space_id: true

  belongs_to :building
  belongs_to :space
  belongs_to :group, optional: true
end
