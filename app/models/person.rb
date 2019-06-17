# frozen_string_literal: true

class Person < ApplicationRecord
  has_paper_trail
  include Validators
  include InputCleaner
  include Categorizable
  include Imageable

  paginates_per 5

  validates :first_name, :last_name, :job_title, presence: true
  validates :email_address, presence: true, email: true
  validates :phone_number, phone_number: true
  validates :spaces, presence: true

  serialize :specialties

  auto_strip_attributes :email_address

  before_validation :normalize_phone_number
  before_validation :burpSpecialties

  has_many :member
  has_many :groups, through: :member, source: :group

  has_many :occupant
  has_many :spaces, through: :occupant, source: :space

  def name
    "#{first_name} #{last_name}"
  end

  alias :label :name
end
