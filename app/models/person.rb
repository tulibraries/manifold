class Person < ApplicationRecord
  include Validators

  validates :first_name, :last_name, :chat_handle, :job_title, :research_identifier, presence: true
 	validates :email_address, presence: true, email: true
 	validates :phone_number, presence: true, phone_number: true
 	validates :spaces, presence: true

  auto_strip_attributes :email_address

  has_many :member
  has_many :groups, through: :member, source: :group

  has_many :occupant
  has_many :spaces, through: :occupant, source: :space

  def name
    "#{first_name} #{last_name}"
  end

end
